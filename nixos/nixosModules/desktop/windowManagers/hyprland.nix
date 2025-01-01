{ config, lib, ... }:
let
  cfg = config.nixosModules.desktop.windowManagers.hyprland;
in
{
  programs.hyprland.enable = lib.mkIf cfg.enable true;

  environment.sessionVariables.NIXOS_OZONE_WL = lib.mkIf cfg.enable "1";
}
