{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.drives.steamssd2;
  util = import ./util.nix { inherit config lib pkgs; };
in
{
  options.nixosModules.drives.steamssd2 = {
    enable = mkEnableOption "second steam ssd";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      systemd.tmpfiles.rules = [
        "d /mnt/Steam 0755 root root -"
        "d /mnt/Steam/libraries 0755 root root -"

        "d /mnt/Steam/libraries/SSD2 0755 root root -"
        "d /mnt/Steam/Main 0755 root root -"
        "d /mnt/Saves 0755 root root -"
        "d /mnt/Steam/Saves 0755 root root -"
        "d /mnt/Steam/Emulation 0755 root root -"
      ];

      fileSystems = {
        "/mnt/btr/pool/steamssd2" = util.mkMount "steamssd2" [ ];
        "/mnt/Steam/libraries/SSD2" = util.mkMount "steamssd2" [ "subvol=_active/library" ];
        "/mnt/Steam/Main" = util.mkMount "steamssd2" [ "subvol=_active/main" ];
        "/mnt/Saves" = util.mkMount "steamssd2" [ "subvol=_active/saves" ];
        "/mnt/Steam/Saves" = util.mkMount "steamssd2" [ "subvol=_active/saves" ];
        "/mnt/Steam/Emulation" = util.mkMount "steamssd2" [ "subvol=_active/emulation" ];
      };

      services.btrbk.instances = mkIf config.nixosModules.backups.btrbk.enable {
        "daily".settings.volume."/mnt/btr/pool/steamssd2" = {
          subvolume = {
            "_active/library" = { };
            "_active/main" = { };
            "_active/saves" = { };
            "_active/emulation" = { };
          };
        };
      };
    }
    (util.mkWeeklyScrub "steamssd2" "Wed")
  ]);
}
