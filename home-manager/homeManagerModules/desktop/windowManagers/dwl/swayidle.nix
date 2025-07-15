{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl.swayidle;

  lockCmd = "${pkgs.procps}/bin/pgrep hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
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
        { timeout = 300; command = lockCmd; }
        {
          timeout = 330;
          command = "${pkgs.wlopm}/bin/wlopm --off '*'";
          resumeCommand = "${pkgs.wlopm}/bin/wlopm --on '*'";
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
