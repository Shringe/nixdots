{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.desktop.windowManagers.hyprland;
in
{
  options.nixosModules.desktop.windowManagers.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.desktop.windowManagers.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    security.pam.services.hyprlock = { };
  };
}
