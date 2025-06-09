{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl;

  autostartDwl = pkgs.writeShellApplication {
    name = "autostartDwl";
    runtimeInputs = with pkgs; [
      swaybg
      cliphist
      wl-clipboard
      swaynotificationcenter
      waybar
    ];

    text = ''
      swaybg --mode fill --image ${config.stylix.image} &
      waybar &

      wl-paste --watch cliphist store &
      swaync &
    '';
  };
in {
  imports = [
    ./waybar
  ];

  options.homeManagerModules.desktop.windowManagers.dwl = {
    enable = mkEnableOption "Dwl";
  };

  config = mkIf cfg.enable {
    stylix.opacity.terminal = mkForce 0.99;

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
  };
}
