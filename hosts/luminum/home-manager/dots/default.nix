{
  xdg.configFile = {
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
    "alacritty" = {
      source = ./alacritty;
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
