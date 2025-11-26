{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.server.services.homeAssistant;

  domain = config.nixosModules.reverseProxy.domain;
in
{
  options.nixosModules.server.services.homeAssistant = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
    };

    host = mkOption {
      type = types.str;
      # default = config.nixosModules.info.system.ips.local;
      default = "127.0.0.1";
    };

    port = mkOption {
      type = types.port;
      default = 47500;
      # default = 8123;
    };

    description = mkOption {
      type = types.str;
      default = "Smart Home Management";
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://home.${domain}";
    };

    icon = mkOption {
      type = types.str;
      default = "home-assistant.svg";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.homeassistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      # autoStart = true;

      ports = [ "${toString cfg.port}:8123/tcp" ];

      # since no absolute path is given, it will be created in
      # /var/lib/docker/volumes on the host
      volumes = [ "home-assistant:/config" ];

      extraOptions = [
        "--network=host"
      ];
    };

    services.nginx.virtualHosts."home.${domain}" = {
      useACMEHost = domain;
      onlySSL = true;

      extraConfig = ''
        proxy_buffering off;
      '';

      locations."/" = {
        proxyPass = cfg.url;
        proxyWebsockets = true;
      };
    };
  };
}
