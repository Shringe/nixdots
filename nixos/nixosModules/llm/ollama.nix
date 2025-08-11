{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.llm.ollama;

  domain = config.nixosModules.reverseProxy.domain;
in
{
  options.nixosModules.llm.ollama = {
    enable = mkEnableOption "Ollama llm";

    enableCuda = mkOption {
      type = types.bool;
      default = false;
    };

    host = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 47300;
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://ollama.${domain}/api";
    };

    webui = {
      enable = mkEnableOption "Web frontend";

      host = mkOption {
        type = types.string;
        default = config.nixosModules.info.system.ips.local;
      };

      port = mkOption {
        type = types.port;
        default = 47320;
      };

      description = mkOption {
        type = types.string;
        default = "Local LLMs";
      };

      icon = mkOption {
        type = types.string;
        default = "ollama.svg";
      };

      url = mkOption {
        type = types.string;
        default = "http://${cfg.webui.host}:${toString cfg.webui.port}";
      };

      furl = mkOption {
        type = types.string;
        default = "https://ollama.${domain}";
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      ollama = {
        enable = true;
        openFirewall = false;
        host = cfg.host;
        port = cfg.port;

        acceleration = mkIf cfg.enableCuda "cuda";

        loadModels = [
          "llama3.1"
          "deekseek-r1:14b"
          "renchris/qwen3-coder:30b-gguf-unsloth"
        ];
      };

      nextjs-ollama-llm-ui = mkIf cfg.webui.enable {
        enable = true;
        hostname = cfg.webui.host;
        port = cfg.webui.port;
        ollamaUrl = cfg.furl;
      };

      nginx.virtualHosts = {
        "ollama.${domain}" = {
          useACMEHost = domain;
          onlySSL = true;

          locations = {
            "/".proxyPass = cfg.webui.url;
            "/api".proxyPass = cfg.url;
          };
        };
      };
    };
  };
}
