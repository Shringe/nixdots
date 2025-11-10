{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.desktop.windowManagers.mango;
in
{
  imports = [
    inputs.mango.nixosModules.mango
  ];

  options.nixosModules.desktop.windowManagers.mango = {
    enable = mkOption {
      type = types.bool;
      # default = config.nixosModules.desktop.windowManagers.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_RENDERER = "vulkan";
    };

    security = {
      pam.services.hyprlock = { };
      rtkit.enable = true; # For real time audio
    };

    programs.mango.enable = true;

    # xdg.portal = {
    #   enable = true;
    #   config.common.default = [ "wlr" ];
    #   xdgOpenUsePortal = true;
    #
    #   extraPortals = with pkgs; [
    #     xdg-desktop-portal-wlr
    #   ];
    # };

    # services.displayManager.sessionPackages = optional cfg.enable pkgs.mango;
    # services.gnome.gnome-keyring.enable = true;
  };
}
