{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.drives.steamssd1;
  util = import ./util.nix { inherit config lib pkgs; };
in
{
  options.nixosModules.drives.steamssd1 = {
    enable = mkEnableOption "first steam ssd";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      systemd.tmpfiles.rules = [
        "d /mnt/Steam 0755 root root -"
        "d /mnt/Steam/libraries 0755 root root -"

        "d /mnt/Steam/libraries/SSD1 0755 root root -"
      ];

      fileSystems = {
        "/mnt/btr/pool/steamssd1" = util.mkMount "steamssd1" [ ];
        "/mnt/Steam/libraries/SSD1" = util.mkMount "steamssd1" [ "subvol=_active/library" ];
      };

      services.btrbk.instances = mkIf config.nixosModules.backups.btrbk.enable {
        "daily".settings.volume."/mnt/btr/pool/steamssd1" = {
          subvolume = {
            "_active/library" = { };
          };
        };
      };
    }
    (util.mkWeeklyScrub "steamssd1" "Tue")
  ]);
}
