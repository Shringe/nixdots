{ config, lib, ... }:
let
  cfg = config.nixosModules.homepage;
  ip = "http://192.168.0.165";
in {
  config = lib.mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      openFirewall = true;

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
                href = "${ip}:8096";
              };
            }
            {
              "Filebrowser" = {
                description = "Cloud storage and file sharing";
                href = "${ip}:8080";
              };
            }
          ];
        }
      ];
    };
  };
}
