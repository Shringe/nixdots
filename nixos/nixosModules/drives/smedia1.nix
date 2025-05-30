{ config, lib, ... }:
{
  config = {
    fileSystems  = {
      "/defvol/smedia1" = {
        device = "/dev/disk/by-label/smedia1";
        fsType = "btrfs";
        options = [ "noatime" "nofail" ];
      };

      "/mnt/server" = { 
        device = "/dev/disk/by-label/smedia1";
        fsType = "btrfs";
        options = [ "compress=zstd" "noatime" "nofail" ];
      };
    };

    services.btrbk.instances = lib.mkIf config.nixosModules.backups.btrbk.enable {
      "smedia1_Media" = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "1w";
          snapshot_preserve = "4w";

          subvolume = "/defvol/smedia1/Media";
          snapshot_dir = "/defvol/smedia1/_snapshots/Media";
        };
      };

      "smedia1_Emulation" = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "1w";
          snapshot_preserve = "4w";

          subvolume = "/defvol/smedia1/Emulation";
          snapshot_dir = "/defvol/smedia1/_snapshots/Emulation";
        };
      };

      "smedia1_Album" = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "2w";
          snapshot_preserve = "16w";

          subvolume = "/defvol/smedia1/Album";
          snapshot_dir = "/defvol/smedia1/_snapshots/Album";
        };
      };
    };
  };
}
