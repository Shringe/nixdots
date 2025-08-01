{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.sway.swayidle;
in {
  options.homeManagerModules.desktop.windowManagers.sway.swayidle = {
    enable = mkEnableOption "swayidle";
  };

  config = mkIf cfg.enable {
    services.swayidle = {
      enable = true;

      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      ];

      timeouts = [
        { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -f"; }
        {
          timeout = 330;
          command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
          resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
        }
        {
          timeout = 180;
          command = "${pkgs.brightnessctl}/bin/brightnessctl s 80%-";
          resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl s 80%+";        
        }
      ];
    };
  };
}
