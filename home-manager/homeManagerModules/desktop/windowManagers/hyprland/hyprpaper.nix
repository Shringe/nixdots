{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.hyprpaper;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpaper
    ];
  };
  # services.hyprpaper = lib.mkIf cfg.enable {
  #   # enable = true;
  # };
}
