{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl.swayidle;

  lockCmd = "${pkgs.hyprlock}/bin/hyprlock";
in {
  options.homeManagerModules.desktop.windowManagers.dwl.swayidle = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.dwl.enable;
    };
  };

  config = mkIf cfg.enable {
    homeManagerModules.desktop.windowManagers.utils = {
      hyprlock.enable = true;
      swaylock.enable = false;
    };

    services.swayidle = {
      enable = true;

      events = [
        { event = "before-sleep"; command = lockCmd; }
        { event = "lock"; command = lockCmd; }
      ];

      timeouts = [
        { timeout = 330; command = lockCmd; }
        # {
        #   timeout = 300;
        #   command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        #   resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
        # }
        {
          timeout = 180;
          command = "${pkgs.brightnessctl}/bin/brightnessctl s 80%-";
          resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl s 80%+";        
        }
      ];
    };
  };
}
