{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.drives.backups1;
in {
  options.nixosModules.drives.backups1 = {
    enable = mkEnableOption "first backup drive";
  };

  config = mkIf cfg.enable {
    sops.secrets."disks/backups1" = {};

    # Fails because this tries to decrypt earlier than sops can propagate the secret
    # boot.initrd.luks.devices."backups1_crypt" = {
    #   device = "/dev/disk/by-uuid/50d79403-7e11-45d3-8855-8a7a8e2e39f3";
    #   keyFile = config.sops.secrets."disks/backups1".path;
    # };

    # After boot and fs is mounted
    environment.etc.crypttab.text = ''
      backups1_crypt UUID=50d79403-7e11-45d3-8855-8a7a8e2e39f3 ${config.sops.secrets."disks/backups1".path} luks
    '';

    fileSystems."/mnt/btr/backups" = {
      device = "/dev/disk/by-label/backups1";
      fsType = "btrfs";
      options = [ "compress=zstd:5" "noatime" ];
    };
  };
}
