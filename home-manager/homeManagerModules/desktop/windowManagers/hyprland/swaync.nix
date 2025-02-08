{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.swaync;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      swaynotificationcenter
    ];
  };
  # services.swaync = lib.mkIf cfg.enable {
  #   enable = true;
  # };
}
