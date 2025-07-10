{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl;

  autostart = pkgs.writeShellApplication {
    name = "autostartDwl";
    text = ''
      systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
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
        text = ''
          ${pkgs.dwl}/bin/dwl -s "${autostart}/bin/autostartDwl" ; systemctl --user stop dwl-session.target
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
