{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.backups.btrbk;
in {
  options.nixosModules.backups.btrbk = {
    enable = mkEnableOption "Btrfs backup tool";
  };

  config = mkIf cfg.enable {
    services.btrbk = {
      # Option not needed
      # enable = true;
      instances = {
        "home" = {
          onCalendar = "hourly";
          settings = {
            # timestamp_format = "long";
            snapshot_preserve_min = "2w";
            snapshot_preserve = "4w";

            subvolume = "/defvol/root/_active/@home";
            snapshot_dir = "/defvol/root/_snapshots/@home";
          };
        };
      };
    };
  };
}
