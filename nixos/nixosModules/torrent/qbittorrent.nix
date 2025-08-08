{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.torrent.qbittorrent;
in
{
  options.nixosModules.torrent.qbittorrent = {
    enable = mkEnableOption "qBittorrent";
    ports = {
      webui = mkOption {
        type = types.port;
        default = 43080;
      };

      traffic = mkOption {
        type = types.port;
        default = 16403;
      };
    };

    ips = {
      webui = mkOption {
        type = types.string;
        default = "192.168.15.1";
      };
    };

    description = mkOption {
      type = types.string;
      default = "Torrent and Download Client";
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.ips.webui}:${toString cfg.ports.webui}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://torrent.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "qbittorrent.svg";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."user_passwords/qbittorrent".neededForUsers = true;
    users.users.qbittorrent = {
      isNormalUser = true;
      group = "qbittorrent";
      hashedPasswordFile = config.sops.secrets."user_passwords/qbittorrent".path;
    };

    users.groups.qbittorrent = { };

    systemd.tmpfiles.rules = [
      "d /mnt/server/local/qbittorrent 0770 qbittorrent qbittorrent -"
    ];

    systemd.services.qbittorrent = {
      description = "qBittorrent-nox service";
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "nss-lookup.target"
      ];

      serviceConfig = {
        Type = "exec";
        User = "qbittorrent";
        Group = "qbittorrent";
        ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=${toString cfg.ports.webui}";
      };

      wantedBy = [ "multi-user.target" ];

      vpnConfinement = {
        enable = true;
        vpnNamespace = "airvpn";
      };
    };
  };
}
