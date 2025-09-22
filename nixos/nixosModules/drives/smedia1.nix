{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.drives.smedia1;
  util = import ./util.nix { inherit config pkgs; };
in
{
  options.nixosModules.drives.smedia1 = {
    enable = mkEnableOption "first server drive";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      systemd.tmpfiles.rules = [
        "d /mnt/btr/pool/smedia1 0755 root root -"
      ];

      fileSystems = {
        "/mnt/btr/pool/smedia1" = util.mkMount "smedia1" [ ];
        # "/mnt/server/local" = mkMount [ "subvol=_active/local"];
      };

      services.btrbk.instances = mkIf config.nixosModules.backups.btrbk.enable {
        "daily".settings.volume."/mnt/btr/pool/smedia1" = {
          subvolume = {
            # "_active/backups" = {};
            "_active/local" = { };
            "_active/critical" = { };
          };
        };
      };
    }
    (util.mkWeeklyScrub "smedia1" "Thu")
  ]);
}
