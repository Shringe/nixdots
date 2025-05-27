{ config, lib, ... }:
{
  config = {
    fileSystems = { 
      "/defvol/steamssd2" = {
        device = "/dev/disk/by-label/steamssd2";
        fsType = "btrfs";
        options = [ "noatime" "nofail" ];
      };

      "/mnt/Steam/Main" = {
        device = "/dev/disk/by-label/steamssd2";
        fsType = "btrfs";
        options = [ "subvol=_steam/main" "noatime" "nofail" ];
      };

      "/mnt/Steam/libraries/SSD2" = { 
        device = "/dev/disk/by-label/steamssd2";
        fsType = "btrfs";
        options = [ "subvol=_steam/library" "compress=zstd" "noatime" "nofail" ];
      };

      "/mnt/Saves" = { 
        device = "/dev/disk/by-label/steamssd2";
        fsType = "btrfs";
        options = [ "subvol=Saves" "compress=zstd" "noatime" "nofail" ];
      };
    };

    services.btrbk.instances = lib.mkIf config.nixosModules.backups.btrbk.enable {
      "steamssd2_main" = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "1w";
          snapshot_preserve = "2w";

          subvolume = "/defvol/steamssd2/_steam/main";
          snapshot_dir = "/defvol/steamssd2/_snapshots/main";
        };
      };

      "steamssd2_library" = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "1w";
          snapshot_preserve = "2w";

          subvolume = "/defvol/steamssd2/_steam/library";
          snapshot_dir = "/defvol/steamssd2/_snapshots/library";
        };
      };

      "steamssd2_Saves" = {
        onCalendar = "hourly";
        settings = {
          snapshot_preserve_min = "2w";
          snapshot_preserve = "4w";

          subvolume = "/defvol/steamssd2/Saves";
          snapshot_dir = "/defvol/steamssd2/_snapshots/Saves";
        };
      };
    };
  };
}
