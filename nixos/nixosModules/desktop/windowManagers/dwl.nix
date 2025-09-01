{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.desktop.windowManagers.dwl;
in
{
  options.nixosModules.desktop.windowManagers.dwl = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.desktop.windowManagers.enable;
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        dwl
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        WLR_RENDERER = "vulkan";

        # Used for tearing patch
        WLR_DRM_NO_ATOMIC = "1";
      };
    };

    security = {
      pam.services.hyprlock = { };
      rtkit.enable = true; # For real time audio
    };

    xdg.portal = {
      enable = true;
      config.common.default = [ "wlr" ];
      xdgOpenUsePortal = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
    };

    services.displayManager.sessionPackages = optional cfg.enable pkgs.dwl;
    services.gnome.gnome-keyring.enable = true;
  };
}
