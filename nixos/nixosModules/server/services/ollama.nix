{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.server.services.ollama;

  domain = config.nixosModules.reverseProxy.domain;
in
{
  options.nixosModules.server.services.ollama = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
    };

    enableCuda = mkOption {
      type = types.bool;
      default = config.nixpkgs.config.cudaSupport;
    };

    host = mkOption {
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 47300;
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://ollama.${domain}";
    };

    webui = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
      };

      host = mkOption {
        type = types.str;
        default = cfg.host;
      };

      port = mkOption {
        type = types.port;
        default = 47320;
      };

      description = mkOption {
        type = types.str;
        default = "Local LLMs";
      };

      icon = mkOption {
        type = types.str;
        default = "ollama.svg";
      };

      url = mkOption {
        type = types.str;
        default = "http://${cfg.webui.host}:${toString cfg.webui.port}";
      };

      furl = mkOption {
        type = types.str;
        default = "https://oi.${domain}";
      };
    };
  };

  config = mkIf cfg.enable {
    # If this is enabled, it annoyingly gets started on every nixos-rebuild switch
    systemd.services.ollama-model-loader.enable = false;

    services = {
      ollama = {
        enable = true;
        openFirewall = false;
        host = cfg.host;
        port = cfg.port;

        acceleration = mkIf cfg.enableCuda "cuda";

        loadModels = [
          "phi3:mini-4k"
        ];
      };

      open-webui = mkIf cfg.webui.enable {
        enable = true;
        openFirewall = false;
        host = cfg.webui.host;
        port = cfg.webui.port;

        environment = {
          ANONYMIZED_TELEMETRY = "False";
          DO_NOT_TRACK = "True";
          SCARF_NO_ANALYTICS = "True";
          OLLAMA_API_BASE_URL = "${cfg.furl}/api";
          OLLAMA_BASE_URL = cfg.furl;
          ENABLE_OATH_WITHOUT_EMAIL = "True";
          BYPASS_MODEL_ACCESS_CONTROL = "True";
        };
      };

      # nextjs-ollama-llm-ui = mkIf cfg.webui.enable {
      #   enable = true;
      #   hostname = cfg.webui.host;
      #   port = cfg.webui.port;
      #   ollamaUrl = cfg.furl;
      # };

      nginx.virtualHosts = {
        "ollama.${domain}" = {
          useACMEHost = domain;
          onlySSL = true;

          locations."/" = {
            proxyPass = cfg.url;
            proxyWebsockets = true;
          };
        };

        "oi.${domain}" = mkIf cfg.webui.enable {
          useACMEHost = domain;
          onlySSL = true;

          locations."/" = {
            proxyPass = cfg.webui.url;
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
