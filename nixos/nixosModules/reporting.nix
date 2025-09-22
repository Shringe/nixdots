{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.reporting;

  matrixReport = pkgs.writeShellApplication {
    name = "matrixReport";

    runtimeInputs = with pkgs; [
      coreutils
      curl
      jq
    ];

    text = ''
      msg=$(jq -n --arg body "$1" '{msgtype: "m.text", body: $body}')
      printf "Reporting message to matrix:\n%s" "$msg"
      curl -X PUT \
        -H "Authorization: Bearer $MATRIX_REPORT_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$msg" \
        "https://$MATRIX_REPORT_SERVER/_matrix/client/r0/rooms/$MATRIX_REPORT_ROOM:$MATRIX_REPORT_SERVER/send/m.room.message/$(date +%s)"
    '';
  };

  scrubAll = pkgs.writeShellApplication {
    name = "scrubAll";

    runtimeInputs = with pkgs; [
      btrfs-progs
      coreutils
      matrixReport
    ];

    text = ''
      echo "Beginning scrubbing of all filesystems..."
      btrfs scrub start -B /mnt/btr/pool/root
      btrfs scrub start -B /mnt/btr/pool/smedia1
      btrfs scrub start -B /mnt/btr/pool/smedia2
      btrfs scrub start -B /mnt/btr/pool/steamssd1
      btrfs scrub start -B /mnt/btr/pool/steamssd2
      echo "Finished scrubbing."

      echo "Reporting results to matrix..."
      rootOut=$(btrfs scrub status /mnt/btr/pool/root)
      smedia1Out=$(btrfs scrub status /mnt/btr/pool/smedia1)
      smedia2Out=$(btrfs scrub status /mnt/btr/pool/smedia2)
      steamssd1Out=$(btrfs scrub status /mnt/btr/pool/steamssd1)
      steamssd2Out=$(btrfs scrub status /mnt/btr/pool/steamssd2)
      report=$(cat <<EOF
      Btrfs Scrub Report ---
      Root
      \`\`\`
      $rootOut
      \`\`\`
      Smedia1
      \`\`\`
      $smedia1Out
      \`\`\`
      Smedia2
      \`\`\`
      $smedia2Out
      \`\`\`
      Steamssd1
      \`\`\`
      $steamssd1Out
      \`\`\`
      Steamssd2
      \`\`\`
      $steamssd2Out
      \`\`\`
      EOF
      )

      matrixReport "$report"
    '';
  };
in
{
  options.nixosModules.reporting = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Automatic scrubbing and reporting of system information to matrix";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."social/matrix/matrixReport" = { };

    systemd.services.btrfs-scrub = {
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${scrubAll}/bin/scrubAll";
        EnvironmentFile = config.sops.secrets."social/matrix/matrixReport".path;
      };
    };

    systemd.timers.btrfs-scrub = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "weekly";
        RandomizedDelaySec = "4h";
        Persistent = true;
      };
    };
  };
}
