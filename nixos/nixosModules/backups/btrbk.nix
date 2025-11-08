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
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "3d";
          snapshot_preserve = "14d 2w";

          target_preserve_min = "no";
          target_preserve = "4w 2m";

          snapshot_dir = "_snapshots";
        };
      };
    };
  };
}
