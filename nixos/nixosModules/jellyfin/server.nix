{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.jellyfin.server;
in
{
  options.nixosModules.jellyfin.server = {
    enable = mkEnableOption "Jellyfin hosting";

    port = mkOption {
      type = types.port;
      default = 47040;
    };

    description = mkOption {
      type = types.string;
      default = "Media Streaming";
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://jellyfin.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "jellyfin.svg";
    };
  };

  config = mkIf cfg.enable {
    nixosModules.jellyfin.jellyseerr.enable = mkDefault false;
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

    services.jellyfin = {
      enable = true;
    };
  };
}
