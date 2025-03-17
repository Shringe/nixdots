{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.uptimeKuma;
in {
  options.nixosModules.uptimeKuma = {
    enable = mkEnableOption "Status monitor";
    
    port = mkOption {
      type = types.port;
      default = 47080;
    };

    ip = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };

    description = mkOption {
      type = types.string;
      default = "Server Status Monitor";
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.ip}:${toString cfg.port}";
    };

    icon = mkOption {
      type = types.string;
      default = "uptime-kuma.svg";
    };
  };

  config = mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
      settings = {
        PORT = toString cfg.port; 
        UPTIME_KUMA_HOST= cfg.ip;
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
