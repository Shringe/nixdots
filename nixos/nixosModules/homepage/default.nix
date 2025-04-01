{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.homepage;

  fixedPaths = pkgs.homepage-dashboard.overrideAttrs (oldAttrs: {
    postInstall = ''
      mkdir -p $out/share/homepage/public/images
      ln -s ${cfg.wallpaper} $out/share/homepage/public/images/wallpaper.png
      ln -s ${../themes/icons} $out/share/homepage/public/icons
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
      default = ../themes/wallpapers/TerribleFate.png;
    };
  };

  config = lib.mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      listenPort = cfg.port;
      openFirewall = true;
      package = fixedPaths;

      settings = {
        background = {
          image = "/images/wallpaper.png";
          blur = "sm";
          saturate = 75;
          brightness = 75;
        };

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
        { "Files and Documents" = [
          {
            "File Browser" = with filebrowser; { 
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
          {
            "Radicale" = with caldav.radicale; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
          {
            "Immich" = with album.immich; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
        ];}

        { "Server Health" = [
          {
            "Uptime Kuma" = with uptimeKuma; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
          {
            "Gatus" = with monitors.gatus; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
        ];}

        { "Administrator" = [
          {
            "Guacamole" = with guacamole; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
          {
            "Router Settings" = { 
              description = "Networking Admin Panel";
              href = "http://192.168.0.1";
              icon = "/icons/router.svg";
            };
          }
          {
            "AdGuard Home" = with adblock.adguard; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
        ];}

        { "Media" = [
          {
            "Jellyseerr" = with jellyfin.jellyseerr; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
          {
            "Ombi" = with ombi; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
          {
            "Jellyfin" = with jellyfin.server; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
        ];}

        { "Yarr!" = [
          {
            "Automatic Ripping Machine" = with docker.automaticrippingmachine; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
          {
            "Lidarr" = with arrs.lidarr; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
          {
            "Radarr" = with arrs.radarr; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
          {
            "Sonarr" = with arrs.sonarr; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
          {
            "Prowlarr" = with arrs.prowlarr; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
          {
            "qBittorrent" = with torrent.qbittorrent; {
              description = description;
              href = url;
              icon = "/icons/${icon}";
            };
          }
        ];} 
      ];
    };
  };
}
