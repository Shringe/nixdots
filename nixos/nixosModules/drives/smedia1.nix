{
  fileSystems."/mnt/server" = { 
    # device = "/dev/disk/by-uuid/04346207-351b-4696-94bd-e0b93d4b8d9c";
    device = "/dev/disk/by-label/smedia1";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "nofail" ];
  };
}
