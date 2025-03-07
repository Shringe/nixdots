{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.jellyfin.client;
in
{
  options.nixosModules.jellyfin.client = {
    enable = mkEnableOption "Jellyfin client";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      jellyfin-media-player
      jellyfin-tui
    ];
  };
}
