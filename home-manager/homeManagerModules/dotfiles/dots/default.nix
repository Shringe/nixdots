{ config, lib, ... }:
{
  xdg.configFile = lib.mkIf config.homeManagerModules.dotfiles.enable {
    "picom.conf" = {
      source = ./picom.conf;
    };
    "wallpapers" = {
      source = ./wallpapers;
      recursive = true;
    };
    "ranger" = {
      source = ./ranger;
      recursive = true;
    };
    "dunst" = {
      source = ./dunst;
      recursive = true;
    };
    "wofi-power-menu" = {
      source = ./wofi-power-menu;
    };
  };

  # home.file = {
  #   ".local/bin/media-control" = {
  #     source = ./bin/media-control;
  #   };
  # };
}
