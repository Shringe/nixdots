{
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
}
