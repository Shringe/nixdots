{ config, lib, ... }:
{
  config = {
    fileSystems = { 
      "/defvol/steamssd1" = {
        device = "/dev/disk/by-label/steamssd1";
        fsType = "btrfs";
        options = [ "noatime" "nofail" ];
      };

      "/mnt/Steam/Main" = {
        device = "/dev/disk/by-label/steamssd1";
        fsType = "btrfs";
        options = [ "subvol=_steam/main" "noatime" "nofail" ];
      };

      "/mnt/Steam/libraries/SSD1" = { 
        device = "/dev/disk/by-label/steamssd1";
        fsType = "btrfs";
        options = [ "subvol=_steam/library" "compress=zstd" "noatime" "nofail" ];
      };
    };

    services.btrbk.instances = lib.mkIf config.nixosModules.backups.btrbk.enable {
      "steamssd1_main" = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "1w";
          snapshot_preserve = "2w";

          subvolume = "/defvol/steamssd1/_steam/main";
          snapshot_dir = "/defvol/steamssd1/_snapshots/main";
        };
      };

      "steamssd1_library" = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "1w";
          snapshot_preserve = "2w";

          subvolume = "/defvol/steamssd1/_steam/library";
          snapshot_dir = "/defvol/steamssd1/_snapshots/library";
        };
      };
    };
  };
}
