{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.social.matrix.conduit;

  domain = config.nixosModules.reverseProxy.aDomain;
in {
  options.nixosModules.social.matrix.conduit = {
    enable = mkEnableOption "Matrix conduit server";

    host = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 47340;
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://matrix.${domain}";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."social/matrix/conduit" = {};
    systemd.services.conduit.serviceConfig.EnvironmentFile = config.sops.secrets."social/matrix/conduit".path;


    services.matrix-conduit = {
      enable = true;

      settings.global = {
        address = cfg.host;
        port = cfg.port;
        server_name = domain;

        allow_encryption = true;
        allow_federation = true;
        allow_registration = true;

        database_backend = "rocksdb";
      };
    };
  };
}
