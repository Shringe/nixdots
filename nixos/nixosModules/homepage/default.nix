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
  imports = [
    ./services.nix
  ];

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
      allowedHosts = "dash.${config.nixosModules.reverseProxy.domain}";

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

        statusStyle = "dot";
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
      ]; 
    };
  };
}
