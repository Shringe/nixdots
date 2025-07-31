{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.drives.smedia2;
in {
  options.nixosModules.drives.smedia2 = {
    enable = mkEnableOption "second server array";
  };

  config = mkIf cfg.enable {
    sops.secrets."disks/smedia2" = {};

    # After boot and fs is mounted
    environment.etc.crypttab.text = ''
      smedia2a_crypt UUID=57bb2095-9be2-490f-98a5-d2c33accfc54 ${config.sops.secrets."disks/smedia2".path} luks,nofail
    '';

    fileSystems = {
      "/mnt/btr/pool/smedia2" = {
        device = "/dev/disk/by-label/smedia2";
        fsType = "btrfs";
        options = [ "compress=zstd" "noatime" "nofail" ];
      };

      "/mnt/server2" = { 
        device = "/dev/disk/by-label/smedia2";
        fsType = "btrfs";
        options = [ "compress=zstd" "noatime" "nofail" "subvol=_active" ];
      };
    };
  };
}
