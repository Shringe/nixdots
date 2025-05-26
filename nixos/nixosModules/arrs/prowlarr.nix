{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.prowlarr;
in {
  options.nixosModules.arrs.prowlarr = {
    enable = mkEnableOption "Prowlarr Indexer Management";

    ip = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 43060;
    };

    description = mkOption {
      type = types.string;
      default = "Indexer Management";
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.ip}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://prowlarr.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "prowlarr.svg";
    };
  };

  config = mkIf cfg.enable {
    # users.users.prowlarr = {
    #   isSystemUser = true;
    #   group = "prowlarr";
    #   extraGroups = [ "qbittorrent" ];
    # };

    # users.groups.prowlarr = { };

    services.prowlarr = {
      enable = true;
      settings = {
        server.port = cfg.port;
      };
    };
  };
}
