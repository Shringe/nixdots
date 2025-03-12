{ config, lib, ... }:
let
  cfg = config.nixosModules.homepage;
  ip = "http://${cfg.ip}";
in {
  options.nixosModules.homepage = {
    enable = lib.mkEnableOption "Homepage dashboard";
    port = lib.mkOption {
      type = lib.types.port;
      default = 47020;
    };

    ip = lib.mkOption {
      type = lib.types.string;
      default = config.nixosModules.info.system.ips.local;
    };
  };

  config = lib.mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      listenPort = cfg.port;

      settings = {
        background = {
          # image = ./background.jpg;
          image = "https://wallpapercave.com/wp/wp3657379.jpg";
        };
      };

      services = [
        {
          "Yarr!" = [
            {
              "File Browser" = {
                description = "Cloud Storage and File Sharing";
                href = "${ip}:${toString config.nixosModules.filebrowser.port}";
              };
            }
            {
              "Uptime Kuma" = {
                description = "Server Status Monitor";
                href = "${ip}:${toString config.nixosModules.uptimeKuma.port}";
              };
            }
            {
              "Guacamole" = {
                description = "OpenSSH Web Client";
                href = "${ip}:${toString config.nixosModules.guacamole.port}";
              };
            }
            {
              "Router Settings" = {
                description = "Networking Admin Panel";
                href = "http://192.168.0.1";
              };
            }
            {
              "AdGuard Home" = {
                description = "Network-Wide Ad Blocker";
                href = "${ip}:${toString config.nixosModules.adblock.adguard.ports.webui}";
              };
            }
            { 
              "Jellyseerr" = {
                description = "Media Requests";
                href = "${ip}:${toString config.nixosModules.jellyfin.jellyseerr.port}";
              };
            }
            { 
              "Ombi" = {
                description = "All-In-One Media Requests Hub";
                href = "${ip}:${toString config.nixosModules.ombi.port}";
              };
            }
            { 
              "Jellyfin" = {
                description = "Media Streaming";
                href = "${ip}:${toString config.nixosModules.jellyfin.server.port}";
              };
            }
            {
              "Automatic Ripping Machine" = {
                description = "Automatically rips DVDs, Blue-Rays, and CDs";
                href = "${ip}:${toString config.nixosModules.docker.automaticrippingmachine.port}";
              };
            }
            {
              "Lidarr" = {
                description = "Music Management";
                href = "${ip}:${toString config.nixosModules.arrs.lidarr.port}";
              };
            }
            {
              "Radarr" = {
                description = "Movie Show Management";
                href = "${ip}:${toString config.nixosModules.arrs.radarr.port}";
              };
            }
            {
              "Sonarr" = {
                description = "TV Show Management";
                href = "${ip}:${toString config.nixosModules.arrs.sonarr.port}";
              };
            }
            {
              "Prowlarr" = {
                description = "Indexer Management";
                href = "${ip}:${toString config.nixosModules.arrs.prowlarr.port}";
              };
            }
            {
              "qBittorrent" = {
                description = "Torrent and Download Client";
                href = "http://${config.nixosModules.torrent.qbittorrent.ips.webui}:${toString config.nixosModules.torrent.qbittorrent.ports.webui}";
              };
            }
          ];
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
