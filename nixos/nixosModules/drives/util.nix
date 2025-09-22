{
  config,
  lib,
  pkgs,
  ...
}:
let
  scrubReportNu = pkgs.writers.writeNu "scrubReport" {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      "${lib.makeBinPath (
        with pkgs;
        [
          btrfs-progs
          util-linux
          config.nixosModules.reporting.matrixReport
        ]
      )}"
    ];
  } (builtins.readFile ./scrub_report.nu);
in
{
  mkWeeklyScrub = label: day: {
    systemd.services."btrfs-scrub-${label}" = lib.mkIf config.nixosModules.reporting.enable {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.btrfs-progs}/bin/btrfs scrub start -B /dev/disk/by-label/${label}";
        ExecStopPost = "${scrubReportNu}/bin/scrubReport ${label}";
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
