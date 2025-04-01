{
  fileSystems = { 
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
}
