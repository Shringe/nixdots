{ config, lib, ... }:
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
    programs.hyprland.enable = true;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    security.pam.services.hyprlock = { };
  };
}
