{ config, lib, ... }:
let
  cfg = config.nixosModules.homepage;
  ip = "http://${cfg.ip}";
in {
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
                description = "Cloud storage and file sharing";
                href = "${ip}:${toString config.nixosModules.filebrowser.port}";
              };
            }
            {
              "Uptime Kuma" = {
                description = "Server status monitor";
                href = "${ip}:${toString config.nixosModules.uptimeKuma.port}";
              };
            }
            {
              "Router Settings" = {
                description = "Networking admin panel";
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
              "Jellyfin" = {
                description = "Media streaming";
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
                description = "Music management";
                href = "${ip}:${toString config.nixosModules.arrs.lidarr.port}";
              };
            }
          ];
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
