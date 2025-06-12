{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl;

  autostartDwl = pkgs.writeShellApplication {
    name = "autostartDwl";
    runtimeInputs = with pkgs; [
      dbus
    ];

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY NIXOS_OZONE_WL
      systemctl --user start dwl-session.target
    '';
  };
in {
  imports = [
    ./waybar
    ./swayidle.nix
    ./swaybg.nix
  ];

  options.homeManagerModules.desktop.windowManagers.dwl = {
    enable = mkEnableOption "Dwl";
  };

  config = mkIf cfg.enable {
    stylix.opacity.terminal = mkForce 0.99;

    homeManagerModules.desktop.windowManagers.utils = {
      wofi.enable = true;
      swaync.enable = true;
      cliphist.enable = true;
    };

    home.packages = with pkgs; [
      dwl

      (writeShellApplication {
        name = "sdwl";
        runtimeInputs = [
          dwl
          autostartDwl
        ];

        text = ''
          dwl -s "autostartDwl"
        '';
      })
    ];

    systemd.user.targets.dwl-session.Unit = {
      Description = "dwl compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [
        "graphical-session-pre.target"
      ];
      After = [ "graphical-session-pre.target" ];
    };
  };
}
