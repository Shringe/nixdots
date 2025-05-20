{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.cliphist;
in
{
  config = {
    home.packages = with pkgs; lib.mkIf cfg.enable [
      wl-clipboard
      cliphist
    ];

    services.cliphist = lib.mkIf cfg.enable {
      enable = true;
      systemdTargets = ["sway-session.target"];
      allowImages = true;

      extraOptions = [
        "-max-items"
        "100"
      ];
    };
  };
}
