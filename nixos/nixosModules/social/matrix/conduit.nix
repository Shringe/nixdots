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
  };

  config = mkIf cfg.enable {
    services.matrix-conduit = {
      enable = true;

      settings.global = {
        address = cfg.host;
        port = cfg.port;
        server_name = "deamicis.top";

        allow_encryption = true;
        allow_federation = false;
        allow_registration = true;

        database_backend = "rocksdb";
      };
    };
  };
}
