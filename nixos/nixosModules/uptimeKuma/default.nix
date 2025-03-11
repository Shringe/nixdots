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
