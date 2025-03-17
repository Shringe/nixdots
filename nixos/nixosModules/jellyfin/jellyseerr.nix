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
      type = types.string;
      default = "Media Requests";
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    icon = mkOption {
      type = types.string;
      default = "jellyseerr.svg";
    };
  };

  config = mkIf cfg.enable {
    services.jellyseerr = {
      enable = true;
      port = cfg.port;
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
