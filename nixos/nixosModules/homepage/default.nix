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
          "Main" = [
            {
              "Jellyfin" = {
                description = "Media streaming";
                href = "${ip}:${toString config.nixosModules.jellyfin.server.port}";
              };
            }
            {
              "Filebrowser" = {
                description = "Cloud storage and file sharing";
                href = "${ip}:${toString config.nixosModules.filebrowser.port}";
              };
            }
          ];
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
