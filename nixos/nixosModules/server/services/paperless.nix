{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.server.services.paperless;

  domain = config.nixosModules.reverseProxy.domain;
in
{
  options.nixosModules.server.services.paperless = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
    };

    host = mkOption {
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 47440;
    };

    description = mkOption {
      type = types.str;
      default = "Document Management";
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://paperless.${domain}";
    };

    icon = mkOption {
      type = types.str;
      default = "paperless-ngx.svg";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."server/services/paperless" = { };

    services.paperless = {
      enable = true;
      address = cfg.host;
      port = cfg.port;
      passwordFile = config.sops.secrets."server/services/paperless".path;

      settings = {
        USE_X_FORWARD_PORT = true;
        USE_X_FORWARD_HOST = true;
        PAPERLESS_PROXY_SSL_HEADER = [
          "HTTP_X_FORWARDED_PROTO"
          "https"
        ];

        PAPERLESS_URL = cfg.furl;
        PAPERLESS_CSRF_TRUSTED_ORIGINS = cfg.furl;
        PAPERLESS_ALLOWED_HOSTS = "paperless.${domain}";
      };
    };
  };
}
