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
        type = types.str;
        default = "192.168.15.1";
      };
    };

    description = mkOption {
      type = types.str;
      default = "Torrent and Download Client";
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.ips.webui}:${toString cfg.ports.webui}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://torrent.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.str;
      default = "qbittorrent.svg";
    };
  };

  config = mkIf cfg.enable {
    users.users.qbittorrent = {
      isSystemUser = true;
      group = "qbittorrent";
    };

    users.groups.qbittorrent = { };

    systemd.tmpfiles.rules = [
      "d /mnt/server/local/qbittorrent 0770 qbittorrent qbittorrent -"
      "d /var/lib/qbittorrent 0700 qbittorrent qbittorrent -"
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
        ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=${toString cfg.ports.webui} --profile=/var/lib/qbittorrent";
        Nice = 17;
        IOSchedulingClass = "idle";
        # IOSchedulingClass = "best-effort";
      };

      wantedBy = [ "multi-user.target" ];

      vpnConfinement = {
        enable = true;
        vpnNamespace = "airvpn";
      };
    };
  };
}
