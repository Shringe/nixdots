{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.server.services.tmodloader;
  domain = config.nixosModules.reverseProxy.domain;
in
{
  options.nixosModules.server.services.tmodloader = {
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
      default = 47520;
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://tmodloader.${domain}";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
