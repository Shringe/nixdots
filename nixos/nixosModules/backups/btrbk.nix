{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.backups.btrbk;
in
{
  options.nixosModules.backups.btrbk = {
    enable = mkEnableOption "Btrfs backup tool";
  };

  config = mkIf cfg.enable {
    services.btrbk.instances = {
      "btrbk" = {
        # onCalendar = "daily";
        onCalendar = "hourly";
        settings = {
          snapshot_preserve_min = "2d";
          snapshot_preserve = "7d 24h";

          target_preserve_min = "no";
          target_preserve = "4w 2m";

          snapshot_dir = "_snapshots";
        };
      };
    };
  };
}
