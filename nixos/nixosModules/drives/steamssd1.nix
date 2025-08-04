{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.drives.steamssd1;

  mkMount = extraOpts: {
    device = "/dev/disk/by-label/steamssd1";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "nofail" ] ++ extraOpts;
  };
in {
  options.nixosModules.drives.steamssd1 = {
    enable = mkEnableOption "first steam ssd";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /mnt/Steam 0755 root root -"
      "d /mnt/Steam/libraries 0755 root root -"

      "d /mnt/Steam/libraries/SSD1 0755 root root -"
    ];

    fileSystems = { 
      "/mnt/btr/pool/steamssd1" = mkMount [];
      "/mnt/Steam/libraries/SSD1" = mkMount [ "subvol=_active/library" ];
    };

    services.btrbk.instances = mkIf config.nixosModules.backups.btrbk.enable {
      "daily".settings.volume."/mnt/btr/pool/steamssd1" = {
        subvolume = {
          "_active/library" = {};
        };
      };
    };
  };
}
