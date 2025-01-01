{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.qtile;
in
{
  xdg.configFile."qtile" = lib.mkIf cfg.enable {
      source = ./config;
      recursive = true;
  };

  home.packages = lib.mkIf cfg.enable [
    pkgs.picom
    pkgs.flameshot
    pkgs.ranger
    pkgs.alacritty
    pkgs.dunst
    # pkgs.rofi-emoji
    pkgs.emojipick
    pkgs.rofi
    pkgs.rofi-power-menu
  ];
}

