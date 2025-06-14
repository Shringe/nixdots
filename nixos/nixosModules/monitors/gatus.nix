{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.monitors.gatus;

  watch = name: url: {
    name = name;
    url = url;
    interval = "30m";
    conditions = [
      "[STATUS] == 200"
    ];
  };
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

        endpoints = [
          (watch "Radicale" caldav.radicale.furl)
          (watch "Jellyfin" jellyfin.server.furl)
          (watch "File Browser" filebrowser.furl)
          # (watch "Uptime Kuma" uptimeKuma.furl)
          (watch "Gatus" monitors.gatus.furl)
          # (watch "Guacamole" guacamole.furl)
          (watch "AdGuard Home" adblock.adguard.furl)
          (watch "Jellyseerr" jellyfin.jellyseerr.furl)
          # (watch "Ombi" ombi.furl)
          (watch "Kavita" kavita.furl)
          (watch "Tandoor" groceries.tandoor.furl)
          (watch "Immich" album.immich.furl)
          (watch "Ollama" llm.ollama.webui.furl)

          # (watch "Automatic Ripping Machine" docker.automaticrippingmachine.url)
          (watch "Lidarr" arrs.lidarr.url)
          (watch "Radarr" arrs.radarr.url)
          (watch "Sonarr" arrs.sonarr.url)
          (watch "Prowlarr" arrs.prowlarr.url)
          (watch "qBittorrent" torrent.qbittorrent.url)
          (watch "Authelia" authelia.furl)
          (watch "Flaresolverr" arrs.flaresolverr.url)
          (watch "Atuin" shell.atuin.server.furl)
          (watch "RomM" docker.romm.furl)
          (watch "Linkwarden" linkwarden.furl)
          (watch "OurShoppingList" docker.ourshoppinglist.furl)
          (watch "Nextcloud" nextcloud.furl)
        ];
      };
    };
  };
}
