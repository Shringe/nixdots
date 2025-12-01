{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.monitors.gatus;

  mkMonitor =
    name: module:
    optional module.enable [
      {
        name = name;
        url = if module ? furl then module.furl else module.url;
        interval = "10m";
        conditions = [ "[STATUS] == 200" ];

        alerts = [
          {
            type = "matrix";
            enabled = true;
            send-on-resolved = true;
          }
        ];
      }
    ];
in
{
  options.nixosModules.monitors.gatus = {
    enable = mkEnableOption "Gatus server status monitor";

    port = mkOption {
      type = types.port;
      default = 47240;
    };

    description = mkOption {
      type = types.str;
      default = "Better Server Status Monitor";
    };

    url = mkOption {
      type = types.str;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://gatus.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.str;
      default = "gatus.svg";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."gatus" = { };

    services.gatus = {
      enable = true;
      environmentFile = config.sops.secrets."gatus".path;

      settings = with config.nixosModules; {
        web.port = cfg.port;

        alerting.matrix = {
          server-url = config.nixosModules.social.matrix.conduit.furl;
          access-token = "\${MATRIX_ACCESS_TOKEN}";
          internal-room-id = "!E5MUdlKUbI2XBDCWXu:${config.nixosModules.reverseProxy.aDomain}";
        };

        endpoints = flatten [
          (mkMonitor "Radicale" caldav.radicale)
          (mkMonitor "Jellyfin" jellyfin.server)
          (mkMonitor "File Browser" filebrowser)
          (mkMonitor "Uptime Kuma" uptimeKuma)
          (mkMonitor "Gatus" monitors.gatus)
          (mkMonitor "Guacamole" guacamole)
          (mkMonitor "AdGuard Home" server.networking.dns)
          (mkMonitor "Jellyseerr" jellyfin.jellyseerr)
          (mkMonitor "Ombi" ombi)
          (mkMonitor "Kavita" kavita)
          (mkMonitor "Tandoor" groceries.tandoor)
          (mkMonitor "Immich" server.services.immich)
          (mkMonitor "Ollama" llm.ollama.webui)

          (mkMonitor "Automatic Ripping Machine" docker.automaticrippingmachine)
          (mkMonitor "Lidarr" arrs.lidarr)
          (mkMonitor "Radarr" arrs.radarr)
          (mkMonitor "Sonarr" arrs.sonarr)
          (mkMonitor "Prowlarr" arrs.prowlarr)
          (mkMonitor "qBittorrent" torrent.qbittorrent)
          (mkMonitor "Authelia" authelia)
          (mkMonitor "Flaresolverr" arrs.flaresolverr)
          (mkMonitor "Atuin" shell.atuin.server)
          (mkMonitor "RomM" docker.romm)
          (mkMonitor "Linkwarden" linkwarden)
          (mkMonitor "OurShoppingList" docker.ourshoppinglist)
          (mkMonitor "Nextcloud" server.services.nextcloud)
          (mkMonitor "Matrix" social.matrix.conduit)
          (mkMonitor "Traccar" server.services.traccar)
          (mkMonitor "Wallos" docker.wallos)
          (mkMonitor "Paperless" server.services.paperless)
          (mkMonitor "Collabora" server.services.collabora)
          (mkMonitor "SearXNG" server.services.searxng)
          (mkMonitor "Home Assistant" server.services.homeAssistant)
        ];
      };
    };
  };
}
