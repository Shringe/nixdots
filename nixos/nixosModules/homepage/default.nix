{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.homepage;

  fixedPaths = pkgs.homepage-dashboard.overrideAttrs (oldAttrs: {
    postInstall = ''
      mkdir -p $out/share/homepage/public/images
      ln -s ${cfg.wallpaper} $out/share/homepage/public/images/wallpaper.png
      ln -s ${cfg.logo} $out/share/homepage/public/images/logo.png
      ln -s ${../../../assets/icons} $out/share/homepage/public/icons
    '';
  });
in {
  options.nixosModules.homepage = {
    enable = lib.mkEnableOption "Homepage dashboard";

    port = lib.mkOption {
      type = lib.types.port;
      default = 47020;
    };

    wallpaper = mkOption {
      type = types.path;
      default = ../../../assets/wallpapers/TerribleFate.png;
    };

    logo = mkOption {
      type = types.path;
      default = ../../../assets/icons/majora.png;
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."homepage" = {};

    services.homepage-dashboard = {
      enable = true;
      listenPort = cfg.port;
      package = fixedPaths;
      environmentFile = config.sops.secrets."homepage".path;

      settings = {
        background = {
          image = "/images/wallpaper.png";
          blur = "sm";
          saturate = 75;
          brightness = 75;
        };

        favicon = "/images/logo.png";

        # color = "indigo";
        color = "red";
      };

      widgets = [
        {
          resources = {
            cpu = true;
            cputemp = true;
            network = true;
            uptime = true;
            memory = true;
            disk = [
              "/"
              "/mnt/server"
            ];
          };
        }
        {
          datetime = {
            format = {
              dateStyle = "long";
              timeStyle = "long";
            };
          };
        }
        {
          openmeteo = {
            label = "Valley View";
            latitude = 33.487753;
            longitude = -97.164648;
            timezone = "America/Chicago";
            cache = 10; # Checks every 10 minutes
          };
        }
      ];
 
      services = with config.nixosModules; [
        { "Social" = [
          {
            "Ollama" = with llm.ollama.webui; { 
              description = description;
              href = furl;
              icon = "/icons/${icon}";
            };
          }
          {
            "OurShoppingList" = with docker.ourshoppinglist; { 
              description = description;
              href = furl;
              icon = "/icons/${icon}";
            };
          }
          {
            "Tandoor" = with groceries.tandoor; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "tandoor";
                url = furl;
                key = "{{HOMEPAGE_VAR_TANDOOR}}";
              };
            };
          }
        ];}

        { "Files and Documents" = [
          {
            "File Browser" = with filebrowser; { 
              description = description;
              href = furl;
              icon = "/icons/${icon}";
            };
          }
          {
            "Radicale" = with caldav.radicale; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
            };
          }
          {
            "Immich" = with album.immich; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "immich";
                url = furl;
                key = "{{HOMEPAGE_VAR_IMMICH}}";
                version = 2;
              };
            };
          }
        ];}

        { "Server Health" = [
          # {
          #   "Uptime Kuma" = with uptimeKuma; {
          #     description = description;
          #     href = url;
          #     icon = "/icons/${icon}";
          #   };
          # }
          {
            "Gatus" = with monitors.gatus; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "gatus";
                url = furl;
              };
            };
          }
        ];}

        { "Administrator" = [
          # {
          #   "Guacamole" = with guacamole; {
          #     description = description;
          #     href = url;
          #     icon = "/icons/${icon}";
          #   };
          # }
          {
            "Router Settings" = { 
              description = "Networking Admin Panel";
              href = "https://router.${config.nixosModules.reverseProxy.domain}";
              icon = "/icons/router.svg";
            };
          }
          {
            "AdGuard Home" = with adblock.adguard; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "adguard";
                url = furl;
              };
            };
          }
        ];}

        { "Media" = [
          {
            "Jellyseerr" = with jellyfin.jellyseerr; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "jellyseerr";
                url = furl;
                key = "{{HOMEPAGE_VAR_JELLYSEERR}}";
              };
            };
          }
          # {
          #   "Ombi" = with ombi; {
          #     description = description;
          #     href = url;
          #     icon = "/icons/${icon}";
          #     widget = {
          #       type = "ombi";
          #       url = url;
          #       key = "{{HOMEPAGE_VAR_OMBI}}";
          #     };
          #   };
          # }
          {
            "Jellyfin" = with jellyfin.server; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "jellyfin";
                url = furl;
                key = "{{HOMEPAGE_VAR_JELLYFIN}}";
                enableBlocks = true;
                expandOneStreamToTwoRows = false;
              };
            };
          }
          {
            "Kavita" = with kavita; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "kavita";
                url = furl;
                key = "{{HOMEPAGE_VAR_KAVITA}}";
              };
            };
          }
          {
            "RomM" = with docker.romm; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "romm";
                url = furl;
              };
            };
          }
          {
            "Linkwarden" = with linkwarden; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "linkwarden";
                url = furl;
                key = "{{HOMEPAGE_VAR_LINKWARDEN}}";
              };
            };
          }
        ];}

        { "Yarr!" = [
          # {
          #   "Automatic Ripping Machine" = with docker.automaticrippingmachine; {
          #     description = description;
          #     href = url;
          #     icon = "/icons/${icon}";
          #   };
          # }
          {
            "Lidarr" = with arrs.lidarr; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "lidarr";
                url = furl;
                key = "{{HOMEPAGE_VAR_LIDARR}}";
              };
            };
          }
          {
            "Radarr" = with arrs.radarr; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "radarr";
                url = furl;
                key = "{{HOMEPAGE_VAR_RADARR}}";
              };
            };
          }
          {
            "Sonarr" = with arrs.sonarr; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "sonarr";
                url = furl;
                key = "{{HOMEPAGE_VAR_SONARR}}";
              };
            };
          }
          {
            "Prowlarr" = with arrs.prowlarr; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "prowlarr";
                url = furl;
                key = "{{HOMEPAGE_VAR_PROWLARR}}";
              };
            };
          }
          {
            "qBittorrent" = with torrent.qbittorrent; {
              description = description;
              href = furl;
              icon = "/icons/${icon}";
              widget = {
                type = "qbittorrent";
                url = furl;
                username = "{{HOMEPAGE_VAR_QBITTORRENT_USER}}";
                password = "{{HOMEPAGE_VAR_QBITTORRENT_PASS}}";
              };
            };
          }
        ];} 
      ];
    };
  };
}
