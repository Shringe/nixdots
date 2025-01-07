{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.swaync;
in
{
  services.swaync = lib.mkIf cfg.enable {
    enable = true;
  };
}
