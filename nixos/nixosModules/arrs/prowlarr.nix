{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.prowlarr;
in {
  options.nixosModules.arrs.prowlarr = {
    enable = mkEnableOption "Prowlarr Indexer Management";

    ip = mkOption {
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 43060;
    };

    description = mkOption {
      type = types.str;
      default = "Indexer Management";
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.ip}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://prowlarr.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.str;
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
