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
  };

  config = mkIf cfg.enable {
    nixosModules.jellyfin.jellyseerr.enable = mkDefault false;

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

    services.jellyfin = {
      enable = true;
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
