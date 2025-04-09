{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.sway;
in {
  config = mkIf cfg.enable {
    homeManagerModules.desktop.terminals.alacritty.enable = mkDefault true;

    home.packages = with pkgs; [
      kdeconnect
    ];

    wayland.windowManager.sway = {
      enable = true;

      config = rec {
        modifier = "Mod4";
        # Use kitty as default terminal
        terminal = "alacritty"; 
        startup = [
          # Launch Firefox on start
          { command = "firefox"; }
          { command = "waybar"; }
          { command = "kdeconnect-indicator"; }
        ];
      };

      extraOptions = [
        "--unsupported-gpu"
      ];
    };
  };
}
