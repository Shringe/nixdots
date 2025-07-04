{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.social.matrix.conduit;
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
      default = "https://matrix.${config.nixosModules.reverseProxy.domain}";
    };
  };

  config = mkIf cfg.enable {
    services.matrix-conduit = {
      enable = true;

      settings.global = {
        address = cfg.host;
        port = cfg.port;
        server_name = "matrix.${config.nixosModules.reverseProxy.domain}";

        allow_encryption = true;
        allow_federation = false;
        allow_registration = true;
        registration_token = "braintoken";

        database_backend = "rocksdb";
      };
    };
  };
}
