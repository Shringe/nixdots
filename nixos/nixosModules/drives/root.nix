{
  fileSystems = {
    "/defvol/root" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "noatime" ];
    };
  };
}
