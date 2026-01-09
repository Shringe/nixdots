{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  util = import ./util.nix { inherit config lib pkgs; };

  mkSteam = subvolume: {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=${subvolume}"
      "noatime"
    ];
  };
in
{
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
