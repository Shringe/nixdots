{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.monitors.gatus;
in {
  options.nixosModules.monitors.gatus = {
    enable = mkEnableOption "Gatus server status monitor";

    port = mkOption {
      type = types.port;
      default = 47240;
    };

    description = mkOption {
      type = types.string;
      default = "Better Server Status Monitor";
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    icon = mkOption {
      type = types.string;
      default = "gatus.svg";
    };
  };

  config = mkIf cfg.enable {
    services.gatus = {
      enable = true;
      openFirewall = true;

      settings = with config.nixosModules; {
        web.port = cfg.port;

        endpoints = [
          {
            name = "Radicale";
            url = caldav.radicale.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "Jellyfin";
            url = jellyfin.server.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "File Browser";
            url = filebrowser.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "Uptime Kuma";
            url = uptimeKuma.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "Gatus";
            url = monitors.gatus.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "Guacamole";
            url = guacamole.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "AdGuard Home";
            url = adblock.adguard.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "Jellyseerr";
            url = jellyfin.jellyseerr.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "Ombi";
            url = ombi.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "Automatic Ripping Machine";
            url = docker.automaticrippingmachine.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "Lidarr";
            url = arrs.lidarr.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "Radarr";
            url = arrs.radarr.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "Sonarr";
            url = arrs.sonarr.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "Prowlarr";
            url = arrs.prowlarr.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "Flaresolverr";
            url = arrs.flaresolverr.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
          {
            name = "qBittorrent";
            url = torrent.qbittorrent.url;
            interval = "30m";
            conditions = [
              "[STATUS] == 200"
            ];
          }
        ];
      };
    };
  };
}
