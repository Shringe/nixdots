{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.backups.btrbk;
in {
  options.nixosModules.backups.btrbk = {
    enable = mkEnableOption "Btrfs backup tool";
  };

  config = mkIf cfg.enable {
    services.btrbk.instances = {
      "daily" = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "2w";
          snapshot_preserve = "14d 4w";

          # target_preserve_min = "no";
          # target_preserve = "4w 2m";

          snapshot_dir = "_snapshots";
        };
      };
    };
  };
}
