{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.desktop.music.termusic;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      termusic
    ];
  };
}
