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
        interval = "30m";
        conditions = [ "[STATUS] == 200" ];
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
      type = types.string;
      default = "Better Server Status Monitor";
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://gatus.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "gatus.svg";
    };
  };

  config = mkIf cfg.enable {
    services.gatus = {
      enable = true;

      settings = with config.nixosModules; {
        web.port = cfg.port;

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
          (mkMonitor "Traccar" gps.traccar)
          (mkMonitor "Wallos" docker.wallos)
          (mkMonitor "Paperless" server.services.paperless)
          (mkMonitor "Collabora" server.services.collabora)
        ];
      };
    };
  };
}
