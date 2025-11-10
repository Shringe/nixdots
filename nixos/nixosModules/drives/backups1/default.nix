{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.drives.backups1;
in
{
  options.nixosModules.drives.backups1 = {
    enable = mkEnableOption "first backup drive";
  };

  config = mkIf cfg.enable {
    sops.secrets."disks/backups1" = { };

    systemd.tmpfiles.rules = [
      "d /mnt/btr/backups 0755 root root -"
    ];

    # After boot and fs is mounted
    environment.etc.crypttab.text = ''
      backups1_crypt UUID=50d79403-7e11-45d3-8855-8a7a8e2e39f3 ${
        config.sops.secrets."disks/backups1".path
      } luks,nofail
    '';

    fileSystems."/mnt/btr/backups" = {
      device = "/dev/disk/by-label/backups1";
      fsType = "btrfs";
      options = [
        "compress=zstd:5"
        "noatime"
        "nofail"
        "x-systemd.automount"
      ];
    };
  };
}
