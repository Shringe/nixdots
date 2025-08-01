{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl;
in {
  imports = [
    ./waybar
    ./swayidle.nix
    ./swaybg.nix
    ./wlogout.nix
    ./walker.nix
  ];

  options.homeManagerModules.desktop.windowManagers.dwl = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.enable;
    };
  };

  config = mkIf cfg.enable {
    # Lower opacity to compensate for blur
    stylix.opacity = {
      terminal = mkForce 0.80;
      desktop = mkForce 0.80;
    };

    home.packages = with pkgs; [
      grim
      slurp
      playerctl
      brightnessctl
    ];

    homeManagerModules.desktop.windowManagers.utils = {
      wofi.enable = true;
      swaync.enable = true;
      cliphist.enable = true;
      swayosd.enable = true;
    };

    systemd.user.targets.dwl-session.Unit = {
      Description = "dwl compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };
}
