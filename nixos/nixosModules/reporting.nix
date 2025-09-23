{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.reporting;

  scrubAll = pkgs.writeShellApplication {
    name = "scrubAll";

    runtimeInputs = with pkgs; [
      btrfs-progs
      coreutils
      cfg.matrixReport
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

    matrixReport = mkOption {
      type = types.package;
      default = pkgs.writeShellApplication {
        name = "matrixReport";

        runtimeInputs = with pkgs; [
          coreutils
          curl
          jq
        ];

        text = ''
          # shellcheck disable=SC1091
          source ${config.sops.secrets."social/matrix/matrixReport".path}
          msg=$(jq -n \
            --arg body "$1" \
            --arg fbody "$1" \
            '{
              msgtype: "m.text",
              body: $body,
              format: "org.matrix.custom.html",
              formatted_body: $fbody
            }')

          curl -X PUT \
            -H "Authorization: Bearer $MATRIX_REPORT_TOKEN" \
            -H "Content-Type: application/json" \
            -d "$msg" \
            "https://$MATRIX_REPORT_SERVER/_matrix/client/r0/rooms/$MATRIX_REPORT_ROOM:$MATRIX_REPORT_SERVER/send/m.room.message/$(date +%s)"
        '';
      };
      description = "Script used to report system messages to matrix";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."social/matrix/matrixReport" = { };
  };
}
