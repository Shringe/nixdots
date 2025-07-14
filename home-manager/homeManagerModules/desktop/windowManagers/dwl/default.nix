{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl;
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

    home.packages = with pkgs; [
      grim
      slurp
      playerctl
      libpulseaudio
      brightnessctl
    ];

    homeManagerModules.desktop.windowManagers.utils = {
      wofi.enable = true;
      swaync.enable = true;
      cliphist.enable = true;
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
