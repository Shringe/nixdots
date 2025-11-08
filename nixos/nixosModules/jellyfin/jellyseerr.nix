{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.jellyfin.jellyseerr;
in
{
  options.nixosModules.jellyfin.jellyseerr = {
    enable = mkEnableOption "Jellyseerr hosting";

    port = mkOption {
      type = types.port;
      default = 47140;
    };

    description = mkOption {
      type = types.str;
      default = "Media Requests";
    };

    url = mkOption {
      type = types.str;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://jellyseerr.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.str;
      default = "jellyseerr.svg";
    };
  };

  config = mkIf cfg.enable {
    services.jellyseerr = {
      enable = true;
      port = cfg.port;
    };
  };
}
