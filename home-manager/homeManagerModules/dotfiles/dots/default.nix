{ config, lib, ... }:
{
  imports = [ ./qtile ];
  xdg.configFile = lib.mkIf config.homeManagerModules.dotfiles.enable {
    "qtile" = {
      source = ./qtile;
      recursive = true;
    };
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
  };

  # home.file = {
  #   ".local/bin/media-control" = {
  #     source = ./bin/media-control;
  #   };
  # };
}
