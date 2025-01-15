{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.cliphist;
in
{
  home.packages = with pkgs; lib.mkIf cfg.enable [
    wl-clipboard
  ];

  services.cliphist = lib.mkIf cfg.enable {
    enable = true;
    allowImages = true;

    extraOptions = [
      "-max-items"
      "100"
    ];
  };
}
