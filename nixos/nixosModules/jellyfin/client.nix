{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.jellyfin.client;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      jellyfin-media-player
    ];
  };
}
