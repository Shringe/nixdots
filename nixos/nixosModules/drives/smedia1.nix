{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.drives.smedia1;

  mkMount = extraOpts: {
    device = "/dev/disk/by-label/smedia1";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "nofail" ] ++ extraOpts;
  };
in
{
  options.nixosModules.drives.smedia1 = {
    enable = mkEnableOption "first server drive";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /mnt/btr/pool/smedia1 0755 root root -"
    ];

    fileSystems  = {
      "/mnt/btr/pool/smedia1" = mkMount [];
      # "/mnt/server/local" = mkMount [ "subvol=_active/local"];
    };

    services.btrbk.instances = mkIf config.nixosModules.backups.btrbk.enable {
      "daily".settings.volume."/mnt/btr/pool/smedia1" = {
        subvolume = {
          # "_active/backups" = {};
          "_active/local" = {};
          "_active/critical" = {};
        };
      };
    };
  };
}
