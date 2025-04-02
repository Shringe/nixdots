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

    webui = {
      enable = mkEnableOption "Web frontend";

      host = mkOption {
        type = types.string;
        default = config.nixosModules.info.system.ips.local;
      };

      port = mkOption {
        type = types.port;
        default = 47300;
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      ollama = {
        enable = true;
        openFirewall = true;
        acceleration = mkIf cfg.enableCuda "cuda";

        loadModels = [ "llama3.1" ];
      };

      nextjs-ollama-llm-ui = mkIf cfg.webui.enable {
        enable = true;
        hostname = cfg.webui.host;
        port = cfg.webui.port;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.webui.enable [ cfg.webui.port ];
  };
}
