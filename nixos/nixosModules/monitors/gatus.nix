{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.monitors.gatus;
  ip = "http://${cfg.ip}";
  vpnIp = "http://${cfg.vpnIp}";
in {
  options.nixosModules.monitors.gatus = {
    enable = mkEnableOption "Gatus server status monitor";

    port = mkOption {
      type = types.port;
      default = 47240;
    };

    ip = lib.mkOption {
      type = lib.types.string;
      default = config.nixosModules.homepage.ip;
    };

    vpnIp = lib.mkOption {
      type = lib.types.string;
      default = config.nixosModules.homepage.vpnIp;
    };
  };

  config = mkIf cfg.enable {
    services.gatus = {
      enable = true;
      openFirewall = true;

      settings = {
        web.port = cfg.port;

        endpoints = [
          {
            name = "Radicale";
            url = "${ip}:${toString config.nixosModules.caldav.radicale.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.ip}"
            ];
          }
          {
            name = "Jellyfin";
            url = "${ip}:${toString config.nixosModules.jellyfin.server.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.ip}"
            ];
          }
          {
            name = "File Browser";
            url = "${ip}:${toString config.nixosModules.filebrowser.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.ip}"
            ];
          }
          {
            name = "Uptime Kuma";
            url = "${ip}:${toString config.nixosModules.uptimeKuma.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.ip}"
            ];
          }
          {
            name = "Gatus";
            url = "${ip}:${toString config.nixosModules.monitors.gatus.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.ip}"
            ];
          }
          {
            name = "Guacamole";
            url = "${ip}:${toString config.nixosModules.guacamole.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.ip}"
            ];
          }
          {
            name = "AdGuard Home";
            url = "${ip}:${toString config.nixosModules.adblock.adguard.ports.webui}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.ip}"
            ];
          }
          {
            name = "Jellyseerr";
            url = "${ip}:${toString config.nixosModules.jellyfin.jellyseerr.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.ip}"
            ];
          }
          {
            name = "Ombi";
            url = "${ip}:${toString config.nixosModules.ombi.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.ip}"
            ];
          }
          {
            name = "Automatic Ripping Machine";
            url = "${ip}:${toString config.nixosModules.docker.automaticrippingmachine.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.ip}"
            ];
          }
          {
            name = "Lidarr";
            url = "${vpnIp}:${toString config.nixosModules.arrs.lidarr.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.vpnIp}"
            ];
          }
          {
            name = "Radarr";
            url = "${vpnIp}:${toString config.nixosModules.arrs.radarr.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.vpnIp}"
            ];
          }
          {
            name = "Sonarr";
            url = "${vpnIp}:${toString config.nixosModules.arrs.sonarr.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.vpnIp}"
            ];
          }
          {
            name = "Prowlarr";
            url = "${vpnIp}:${toString config.nixosModules.arrs.prowlarr.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.vpnIp}"
            ];
          }
          {
            name = "Flaresolverr";
            url = "${vpnIp}:${toString config.nixosModules.arrs.flaresolverr.port}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.vpnIp}"
            ];
          }
          {
            name = "qBittorrent";
            url = "http://${config.nixosModules.torrent.qbittorrent.ips.webui}:${toString config.nixosModules.torrent.qbittorrent.ports.webui}";
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
              "[IP] == ${cfg.vpnIp}"
            ];
          }
        ];
      };
    };
  };
}
