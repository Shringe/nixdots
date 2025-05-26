{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.llm.ollama;
in {
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
        default = "https://ollama.${config.nixosModules.reverseProxy.domain}";
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      ollama = {
        enable = true;
        openFirewall = true;
        host = cfg.host;
        port = cfg.port;
        # package = pkgs-stable.ollama;

        acceleration = mkIf cfg.enableCuda "cuda";

        loadModels = [ "llama3.1" "qwen2.5-coder" "codellama" "qwen2.5-coder:14b" "gemma3" "deepseek-r1" ];
      };

      nextjs-ollama-llm-ui = mkIf cfg.webui.enable {
        enable = true;
        hostname = cfg.webui.host;
        port = cfg.webui.port;
        ollamaUrl = cfg.url;
      };
    };
  };
}
