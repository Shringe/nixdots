{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.desktop.windowManagers.niri;
in
{
  options.nixosModules.desktop.windowManagers.niri = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.desktop.windowManagers.enable;
    };
  };

  config = mkIf cfg.enable {
    # Doesn't work
    # systemd.user.units."niri.service".text = ''
    #   [Service]
    #   Nice=-2
    # '';

    # systemd.user.targets."xdg-desktop-autostart".enable = mkForce false;

    programs.niri = {
      enable = true;
      # useNautilus = false;
    };

    # xdg.portal = {
    #   enable = true;
    #   xdgOpenUsePortal = true;
    #   extraPortals = [
    #     pkgs.xdg-desktop-portal-gtk
    #     pkgs.xdg-desktop-portal-gnome
    #     pkgs.xdg-desktop-portal-wlr
    #   ];
    #   config = {
    #     common.default = [ "wlr" ];
    #   };
    # };

    xdg.portal = {
      enable = true;
      # config.common.default = [ "wlr" ];
      xdgOpenUsePortal = true;

      extraPortals = with pkgs; [
        # xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];

      config.niri = {
        default = [
          "gnome"
          "gtk"
        ];

        "org.freedesktop.impl.portal.Access" = [ "gtk" ];
        "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      };
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.hyprlock = { };
  };
}
