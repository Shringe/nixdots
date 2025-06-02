{ config, lib, ... }:
with lib;
let 
  cfg = config.nixosModules.gps.traccar;
in {
  options.nixosModules.gps.traccar = {
    enable = mkEnableOption "Traccar";

    port = mkOption {
      type = types.port;
      default = 47400;
    };

    description = mkOption {
      type = types.string;
      default = "Traccar Location Server";
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://traccar.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "traccar.svg";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."gps/traccar" = {};

    services.traccar = {
      enable = true;
      environmentFile = config.sops.secrets."gps/traccar".path;

      settings = {
        "web.port" = (toString cfg.port);

        databasePassword = "$TRACCAR_DB_PASSWORD";
      };
    };
  };
}
