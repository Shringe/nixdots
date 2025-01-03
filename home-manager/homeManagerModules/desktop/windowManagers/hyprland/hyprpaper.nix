{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.hyprpaper;
in
{
  services.hyprpaper = lib.mkIf cfg.enable {
    enable = true;

    settings = {
      preload = [
        "${config.home.homeDirectory}/.config/wallpapers/the_valley.png"
      ];

      wallpaper = [
        "HDMI-A-1, ${config.home.homeDirectory}/.config/wallpapers/the_valley.png"
      ];
    };
  };
}
