{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.hyprpaper;
in
{
  services.hyprpaper = lib.mkIf cfg.enable {
    enable = true;
  };
}
