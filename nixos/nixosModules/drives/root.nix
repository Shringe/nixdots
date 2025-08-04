{ config, lib, ... }:
{
  config = {
    systemd.tmpfiles.rules = [
      "d /mnt/btr 0755 root root -"
      "d /mnt/btr/pool 0755 root root -"
      "d /mnt/btr/backups 0755 root root -"
    ];

    fileSystems = {
      "/defvol/root" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = [ "noatime" "compress=zstd" ];
      };
    };

    services.btrbk.instances."daily".settings.volume."/defvol/root" = lib.mkIf config.nixosModules.backups.btrbk.enable {
      subvolume = {
        "_active/@" = {};
        "_active/@home" = {};
        "_active/log" = {};
      };
    };
  };
}
