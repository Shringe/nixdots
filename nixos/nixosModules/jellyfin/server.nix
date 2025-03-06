{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.jellyfin.server;
in
{
  config = lib.mkIf cfg.enable {
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
