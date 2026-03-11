{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.drives.root;
  util = import ./util.nix { inherit config lib pkgs; };

  mkSteam =
    subvolume:
    mkIf cfg.steam {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=${subvolume}"
        "noatime"
      ];
    };
in
{
  options.nixosModules.drives.root = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    steam = mkEnableOption "steam mounts";
  };

  config = mkMerge [
    {
      systemd.tmpfiles.rules = [
        "d /mnt/btr 0755 root root -"
        "d /mnt/btr/pool 0755 root root -"
        "d /mnt/btr/backups 0755 root root -"

        "d /mnt/btr/pool/root 0755 root root -"
      ];

      fileSystems = {
        "/mnt/btr/pool/root" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "btrfs";
          options = [
            "noatime"
            "compress=zstd"
          ];
        };

        "/mnt/Steam/Main" = mkSteam "_active/steam_main";
        "/mnt/Steam/libraries/SSD3" = mkSteam "_active/steam_library";
      };

      services.btrbk.instances = {
        "btrbk".settings.volume."/mnt/btr/pool/root" = mkIf config.nixosModules.backups.btrbk.enable {
          subvolume = {
            "_active/@" = { };
            "_active/@home" = { };
            "_active/log" = { };
          };
        };
      };
    }
    (util.mkWeeklyScrub "nixos" "Mon")
  ];
}
