{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.homepage;

  mkService =
    name: module: extra: with module; [
      {
        ${name} = mkIf enable (mkMerge [
          {
            description = description;
            icon = "/icons/${icon}";
            href = furl;
            siteMonitor = furl;
          }
          extra
        ]);
      }
    ];
in
{
  config.services.homepage-dashboard.services =
    with config.nixosModules;
    with config.nixosModules.server.services;
    mkIf cfg.enable [
      {
        "Social" =
          [ ]
          ++ mkService "Ollama" llm.ollama.webui { }
          ++ mkService "Tandoor" groceries.tandoor {
            widget = {
              type = "tandoor";
              url = groceries.tandoor.furl;
              key = "{{HOMEPAGE_VAR_TANDOOR}}";
            };
          }
          ++ mkService "OurShoppingList" docker.ourshoppinglist { }
          ++ mkService "Traccar" gps.traccar { };
      }

      {
        "Files and Documents" =
          [ ]
          ++ mkService "Nextcloud" nextcloud {
            widget = {
              type = "nextcloud";
              url = nextcloud.furl;
              username = "nextcloud";
              password = "{{HOMEPAGE_VAR_NEXTCLOUD}}";
            };
          }
          ++ mkService "Collabora" collabora { }
          ++ mkService "Paperless" paperless { }
          ++ mkService "File Browser" filebrowser { }
          ++ mkService "Radicale" caldav.radicale { }
          ++ mkService "Immich" album.immich {
            widget = {
              type = "immich";
              url = album.immich.furl;
              key = "{{HOMEPAGE_VAR_IMMICH}}";
              version = 2;
            };
          };
      }

      {
        "Utility" =
          [ ]
          ++ mkService "Uptime Kuma" uptimeKuma { }
          ++ mkService "Gatus" monitors.gatus {
            widget = {
              type = "gatus";
              url = monitors.gatus.furl;
            };
          }
          ++ mkService "Wallos" docker.wallos { };
      }

      {
        "Administrator" =
          [ ]
          ++ mkService "Guacamole" guacamole { }
          ++ mkService "Router" server.router { }
          ++ mkService "AdGuard Home" server.networking.dns {
            widget = {
              type = "adguard";
              url = server.networking.dns.furl;
            };
          };
      }

      {
        "Media" =
          [ ]
          ++ mkService "Jellyseerr" jellyfin.jellyseerr {
            widget = {
              type = "jellyseerr";
              url = jellyfin.jellyseer.furl;
              key = "{{HOMEPAGE_VAR_JELLYSEERR}}";
            };
          }
          ++ mkService "Ombi" ombi {
            widget = {
              type = "ombi";
              url = ombi.url;
              key = "{{HOMEPAGE_VAR_OMBI}}";
            };
          }
          ++ mkService "Jellyfin" jellyfin.server {
            widget = {
              type = "jellyfin";
              url = jellyfin.server.furl;
              key = "{{HOMEPAGE_VAR_JELLYFIN}}";
              enableBlocks = true;
              expandOneStreamToTwoRows = false;
            };
          }
          ++ mkService "Kavita" kavita {
            widget = {
              type = "kavita";
              url = kavita.furl;
              key = "{{HOMEPAGE_VAR_KAVITA}}";
            };
          }
          ++ mkService "RomM" docker.romm {
            widget = {
              type = "romm";
              url = docker.romm.furl;
            };
          }
          ++ mkService "Linkwarden" linkwarden {
            widget = {
              type = "linkwarden";
              url = linkwarden.furl;
              key = "{{HOMEPAGE_VAR_LINKWARDEN}}";
            };
          };
      }

      {
        "Yarr!" =
          [ ]
          ++ mkService "Automatic Ripping Machine" docker.automaticrippingmachine { }
          ++ mkService "Lidarr" arrs.lidarr {
            widget = {
              type = "lidarr";
              url = arrs.lidarr.furl;
              key = "{{HOMEPAGE_VAR_LIDARR}}";
            };
          }
          ++ mkService "Radarr" arrs.radarr {
            widget = {
              type = "radarr";
              url = arrs.radarr.furl;
              key = "{{HOMEPAGE_VAR_RADARR}}";
            };
          }
          ++ mkService "Sonarr" arrs.sonarr {
            widget = {
              type = "sonarr";
              url = arrs.sonarr.furl;
              key = "{{HOMEPAGE_VAR_SONARR}}";
            };
          }
          ++ mkService "Prowlarr" arrs.prowlarr {
            widget = {
              type = "prowlarr";
              url = arrs.prowlarr.furl;
              key = "{{HOMEPAGE_VAR_PROWLARR}}";
            };
          }
          ++ mkService "qBittorrent" torrent.qbittorrent {
            widget = {
              type = "qbittorrent";
              url = torrent.qbittorrent.furl;
              username = "{{HOMEPAGE_VAR_QBITTORRENT_USER}}";
              password = "{{HOMEPAGE_VAR_QBITTORRENT_PASS}}";
            };
          };
      }
    ];
}
