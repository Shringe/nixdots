{
  config,
  pkgs,
  ...
}:
{
  mkWeeklyScrub = label: day: {
    systemd.services."btrfs-scrub-${label}" = {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "btrfs scrub start -B /dev/disk/by-label/${label}";
        ExecStartPost = pkgs.writeShellScript "btrfs-scrub-${label}" ''
          out=$(${pkgs.btrfs-progs}/bin/btrfs scrub status /dev/disk/by-label/${label})
          ${config.nixosModules.reporting.matrixReport}/bin/matrixReport "<p>Btrfs scrub report for ${label}:</p><code>$out</code>"
        '';

        Nice = 19;
        IOSchedulingClass = 3;
        IOSchedulingPriority = 7;
      };

      requisite = [ "local-fs.target" ];
      after = [ "local-fs.target" ];
    };

    systemd.timers."btrfs-scrub-${label}" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "${day} *-*-* 02:00:00";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };
  };

  mkMount = label: extraOpts: {
    device = "/dev/disk/by-label/${label}";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "nofail"
    ]
    ++ extraOpts;
  };
}
