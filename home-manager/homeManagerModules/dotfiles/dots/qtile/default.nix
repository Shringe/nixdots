{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.wm.qtile;
in
{
  home.packages = lib.mkIf cfg.enable [
    pkgs.picom
    pkgs.flameshot
    pkgs.ranger
    pkgs.alacritty
    pkgs.dunst
    pkgs.unclutter
  ];
}

