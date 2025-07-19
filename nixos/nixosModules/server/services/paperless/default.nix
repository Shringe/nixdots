{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.server.services.paperless;
in {
  options.nixosModules.server.services.paperless = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
    };

    port = mkOption {
      type = types.port;
      default = 47440;
    };

    description = mkOption {
      type = types.string;
      default = "Document Management";
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://paperless.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "paperless-ngx.svg";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."server/services/paperless" = {};

    services.paperless = {
      enable = true;
      address = config.nixosModules.info.system.ips.local;
      port = cfg.port;

      passwordFile = config.sops.secrets."server/services/paperless".path;
    };
  };
}
