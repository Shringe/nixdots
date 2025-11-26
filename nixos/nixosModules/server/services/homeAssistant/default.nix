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
      default = config.nixosModules.info.system.ips.local;
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
    services.home-assistant = {
      enable = true;

      # Enables imperative configuration
      config = null;

      # config = {
      #   default_config = {
      #
      #   };
      #
      #   http = {
      #     server_host = cfg.host;
      #     server_port = cfg.port;
      #
      #     use_x_forwarded_for = true;
      #     trusted_proxies = [
      #       cfg.host
      #     ];
      #   };
      # };

      # defaultIntegrations = mkForce [
      #   "mobile_app"
      #   "application_credentials"
      #   "frontend"
      #   "hardware"
      #   "logger"
      #   "network"
      #   "system_health"
      #   "automation"
      #   "person"
      #   "scene"
      #   "script"
      #   "tag"
      #   "zone"
      #   "counter"
      #   "input_boolean"
      #   "input_button"
      #   "input_datetime"
      #   "input_number"
      #   "input_select"
      #   "input_text"
      #   "schedule"
      #   "timer"
      #   "backup"
      # ];

      extraPackages = ps: with ps; [ psycopg2 ];
      # config.recorder.db_url = "postgresql://@/hass";
      extraComponents = [ "isal" ];
    };

    # services.postgresql = {
    #   ensureDatabases = [ "hass" ];
    #   ensureUsers = [
    #     {
    #       name = "hass";
    #       ensureDBOwnership = true;
    #     }
    #   ];
    # };

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
