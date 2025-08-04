{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.drives.steamssd2;

  mkMount = extraOpts: {
    device = "/dev/disk/by-label/steamssd2";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "nofail" ] ++ extraOpts;
  };
in {
  options.nixosModules.drives.steamssd2 = {
    enable = mkEnableOption "second steam ssd";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /mnt/Steam 0755 root root -"
      "d /mnt/Steam/libraries 0755 root root -"

      "d /mnt/Steam/libraries/SSD2 0755 root root -"
      "d /mnt/Steam/Main 0755 root root -"
      "d /mnt/Saves 0755 root root -"
    ];

    fileSystems = { 
      "/mnt/btr/pool/steamssd2" = mkMount [];
      "/mnt/Steam/libraries/SSD2" = mkMount [ "subvol=_active/library" ];
      "/mnt/Steam/Main" = mkMount [ "subvol=_active/main" ];
      "/mnt/Saves" = mkMount [ "subvol=_active/saves" ];
    };

    services.btrbk.instances = mkIf config.nixosModules.backups.btrbk.enable {
      "daily".settings.volume."/mnt/btr/pool/steamssd2" = {
        subvolume = {
          "_active/library" = {};
          "_active/main" = {};
          "_active/saves" = {};
        };
      };
    };
  };
}
