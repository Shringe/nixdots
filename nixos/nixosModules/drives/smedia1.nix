{ config, lib, ... }:
{
  config = {
    users.groups = {
      "books" = {};
      "manga" = {};
      "shows" = {};
      "movies" = {};
      "music" = {};
    };

    fileSystems  = {
      "/defvol/smedia1" = {
        device = "/dev/disk/by-label/smedia1";
        fsType = "btrfs";
        options = [ "noatime" "nofail" ];
      };

      "/mnt/server" = { 
        device = "/dev/disk/by-label/smedia1";
        fsType = "btrfs";
        options = [ "compress=zstd:4" "noatime" "nofail" "subvol=_active" ];
      };
    };

    services.btrbk.instances = lib.mkIf config.nixosModules.backups.btrbk.enable {
      "daily".settings.volume."/defvol/smedia1" = {
        subvolume = {
          "_active/local" = {};
          "_active/critical" = {
            # target = "/mnt/btr/backups/smedia1";
          };
        };
      };
    };

    # services.btrbk.instances."daily".settings.volume."/defvol/smedia1" = lib.mkIf config.nixosModules.backups.btrbk.enable {
    #   subvolume = {
    #     "_active/local" = {};
    #     "_active/critical" = {};
    #   };
    # };

  #   services.btrbk.instances = lib.mkIf config.nixosModules.backups.btrbk.enable {
  #     "smedia1_Media" = {
  #       onCalendar = "daily";
  #       settings = {
  #         snapshot_preserve_min = "1w";
  #         snapshot_preserve = "4w";
  #
  #         subvolume = "/defvol/smedia1/Media";
  #         snapshot_dir = "/defvol/smedia1/_snapshots/Media";
  #       };
  #     };
  #
  #     "smedia1_Emulation" = {
  #       onCalendar = "daily";
  #       settings = {
  #         snapshot_preserve_min = "1w";
  #         snapshot_preserve = "4w";
  #
  #         subvolume = "/defvol/smedia1/Emulation";
  #         snapshot_dir = "/defvol/smedia1/_snapshots/Emulation";
  #       };
  #     };
  #
  #     "smedia1_Album" = {
  #       onCalendar = "daily";
  #       settings = {
  #         snapshot_preserve_min = "2w";
  #         snapshot_preserve = "16w";
  #
  #         subvolume = "/defvol/smedia1/Album";
  #         snapshot_dir = "/defvol/smedia1/_snapshots/Album";
  #       };
  #     };
  #   };
  };
}
