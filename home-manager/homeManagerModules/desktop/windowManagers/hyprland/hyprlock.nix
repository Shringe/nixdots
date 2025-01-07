{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.hyprlock;
in
{
  programs.hyprlock = lib.mkIf cfg.enable {
    enable = true;
  };
}
