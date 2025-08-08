{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.drives.smedia2;

  mkMount = extraOpts: {
    device = "/dev/disk/by-label/smedia2";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "nofail"
    ]
    ++ extraOpts;
  };
in
{
  options.nixosModules.drives.smedia2 = {
    enable = mkEnableOption "second server array";
  };

  config = mkIf cfg.enable {
    sops.secrets."disks/smedia2" = { };

    users.groups = {
      "books" = { };
      "manga" = { };
      "shows" = { };
      "movies" = { };
      "music" = { };
    };

    systemd.tmpfiles.rules = [
      "d /mnt/btr/pool/smedia2 0755 root root -"
      "d /mnt/server/critical 0755 root root -"
      "d /mnt/server/local 0755 root root -"
      "d /mnt/server/backups 0755 root root -"

      "d /mnt/server/local/Media 0755 root root -"
      "d /mnt/server/local/Media/books 0750 root books -"
      "d /mnt/server/local/Media/manga 0750 root manga -"
      "d /mnt/server/local/Media/shows 0750 sonarr shows -"
      "d /mnt/server/local/Media/movies 0750 radarr movies -"
      "d /mnt/server/local/Media/music 0750 lidarr music -"
    ];

    # After boot and fs is mounted
    environment.etc.crypttab.text = ''
      smedia2a_crypt UUID=5bcfac04-0bdc-4282-a6cd-b7af2197c22c ${
        config.sops.secrets."disks/smedia2".path
      } luks,nofail
    '';

    fileSystems = {
      "/mnt/btr/pool/smedia2" = mkMount [ ];
      "/mnt/server/critical" = mkMount [ "subvol=_active/critical" ];
      "/mnt/server/backups" = mkMount [ "subvol=_active/backups" ];
      "/mnt/server/local" = mkMount [ "subvol=_active/local" ];
    };

    services.btrbk.instances = mkIf config.nixosModules.backups.btrbk.enable {
      "daily".settings.volume."/mnt/btr/pool/smedia2" = {
        subvolume = {
          "_active/backups" = { };
          "_active/local" = { };
          "_active/critical" = { };
        };
      };
    };
  };
}
