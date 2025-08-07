{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.server.services.collabora;

  domain = config.nixosModules.reverseProxy.domain;
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
      default = 47440;
    };

    description = mkOption {
      type = types.string;
      default = "Collaborative Documents";
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://collabora.${domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "paperless-ngx.svg";
    };
  };

  config = mkIf cfg.enable {
    services.collabora-online = {
      enable = true;
      port = cfg.port;
    };
  };
}
