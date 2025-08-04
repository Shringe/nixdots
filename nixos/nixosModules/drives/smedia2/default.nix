{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.drives.smedia2;

  mkMount = extraOpts: {
    device = "/dev/disk/by-label/smedia2";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "nofail" ] ++ extraOpts;
  };
in {
  options.nixosModules.drives.smedia2 = {
    enable = mkEnableOption "second server array";
  };

  config = mkIf cfg.enable {
    sops.secrets."disks/smedia2" = {};

    # After boot and fs is mounted
    environment.etc.crypttab.text = ''
      smedia2a_crypt UUID=5bcfac04-0bdc-4282-a6cd-b7af2197c22c ${config.sops.secrets."disks/smedia2".path} luks,nofail
    '';

    fileSystems = {
      "/mnt/btr/pool/smedia2" = mkMount [];
      "/mnt/server/critical" = mkMount [ "subvol=_active/critical" ];
      "/mnt/server/backups" = mkMount [ "subvol=_active/backups" ];
      "/mnt/server/local" = mkMount [ "subvol=_active/local"];
    };

    services.btrbk.instances = lib.mkIf config.nixosModules.backups.btrbk.enable {
      "daily".settings.volume."/mnt/btr/pool/smedia2" = {
        subvolume = {
          "_active/backups" = {};
          "_active/local" = {};
          "_active/critical" = {};
        };
      };
    };
  };
}
