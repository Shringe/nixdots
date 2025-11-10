{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.server.services.traccar;
in
{
  options.nixosModules.server.services.traccar = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
    };

    port = mkOption {
      type = types.port;
      default = 47400;
    };

    description = mkOption {
      type = types.str;
      default = "Traccar Location Server";
    };

    url = mkOption {
      type = types.str;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://traccar.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.str;
      default = "traccar.svg";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."gps/traccar" = { };

    # Unstable is currently broken and services.traccar.package does not exist for some reason
    nixpkgs.overlays = [
      (self: super: {
        traccar = self.stable.traccar;
      })
    ];

    systemd.services.traccar.serviceConfig.PrivateUsers = mkForce false;

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
