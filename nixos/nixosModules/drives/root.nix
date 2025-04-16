{ config, lib, ... }:
{
  config = {
    fileSystems = {
      "/defvol/root" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = [ "noatime" ];
      };
    };

    services.btrbk.instances = lib.mkIf config.nixosModules.backups.btrbk.enable {
      "root_@" = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "4w";
          snapshot_preserve = "4w";

          subvolume = "/defvol/root/_active/@";
          snapshot_dir = "/defvol/root/_snapshots/@";
        };
      };

      "root_@home" = {
        onCalendar = "hourly";
        settings = {
          snapshot_preserve_min = "4w";
          snapshot_preserve = "16w";

          subvolume = "/defvol/root/_active/@home";
          snapshot_dir = "/defvol/root/_snapshots/@home";
        };
      };

      "root_log" = {
        onCalendar = "hourly";
        settings = {
          snapshot_preserve_min = "2w";
          snapshot_preserve = "4w";

          subvolume = "/defvol/root/_active/log";
          snapshot_dir = "/defvol/root/_snapshots/log";
        };
      };
    };
  };
}
