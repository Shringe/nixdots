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
    # environment.etc."systemd/user/niri.service".text = mkForce ''
    #   [Unit]
    #   Description=A scrollable-tiling Wayland compositor
    #   BindsTo=graphical-session.target
    #   Before=graphical-session.target
    #   Wants=graphical-session-pre.target
    #   After=graphical-session-pre.target
    #
    #   # Wants=xdg-desktop-autostart.target
    #   # Before=xdg-desktop-autostart.target
    #
    #   [Service]
    #   Slice=session.slice
    #   Type=notify
    #   ExecStart=${config.programs.niri.package}/bin/niri --session
    # '';

    systemd.user.targets."xdg-desktop-autostart".enable = mkForce false;

    programs.niri = {
      enable = true;
      useNautilus = false;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.hyprlock = { };
  };
}
