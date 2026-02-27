{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.server.services.collabora;

  domain = config.nixosModules.reverseProxy.aDomain;
in
{
  options.nixosModules.server.services.collabora = {
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
      default = 47460;
    };

    description = mkOption {
      type = types.str;
      default = "Collaborative Documents";
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://collabora.${domain}";
    };

    icon = mkOption {
      type = types.str;
      default = "paperless-ngx.svg";
    };
  };

  config = mkIf cfg.enable {
    services.collabora-online = {
      enable = true;
      port = cfg.port;

      settings = {
        # Rely on reverse proxy for SSL
        ssl = {
          enable = false;
          termination = true;
        };

        # # Listen on loopback interface only, and accept requests from ::1
        # net = {
        #   listen = "loopback";
        #   post_allow.host = [ cfg.host ];
        # };

        # Restrict loading documents from WOPI Host nextcloud.example.com
        storage.wopi = {
          "@allow" = true;
          host = [ "nextcloud.${domain}" ];
        };

        server_name = "collabora.${domain}";
      };

      extraArgs = [
        "--o:security.capabilities=false" # Allows export to pdf
      ];
    };

    services.nginx.virtualHosts."collabora.${domain}" = {
      useACMEHost = domain;
      onlySSL = true;

      locations."/" = {
        proxyPass = cfg.url;
        proxyWebsockets = true;
      };
    };
  };
}
