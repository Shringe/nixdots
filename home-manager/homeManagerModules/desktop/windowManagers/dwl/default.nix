{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl;
in
{
  imports = [
    ./waybar
  ];

  options.homeManagerModules.desktop.windowManagers.dwl = {
    enable = mkOption {
      type = types.bool;
      # default = config.homeManagerModules.desktop.windowManagers.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # Lower opacity to compensate for blur
    stylix.opacity = {
      terminal = mkForce 0.70;
      desktop = mkForce 0.70;
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
      dolphin.enable = true;
      polkit.enable = true;
      systemd.enable = true;
      wlogout.enable = true;
      swayidle.enable = true;
      swaybg.enable = true;
    };
  };
}
