{ config, lib, ... }:
let
  cfg = config.nixosModules.desktop.windowManagers.hyprland;
in
{
  programs.hyprland.enable = lib.mkIf cfg.enable true;

  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = lib.mkIf cfg.enable "1";

  # Needed for hyprlock
  security.pam.services.hyprlock = lib.mkIf cfg.enable {};
}
