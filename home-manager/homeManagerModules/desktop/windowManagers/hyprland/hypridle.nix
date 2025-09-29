{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.hypridle;
in
{
  options.homeManagerModules.desktop.windowManagers.hyprland.hypridle = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.hyprland.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl
    ];

    services.hypridle = {
      enable = true;
      systemdTarget = "hyprland-session.target";

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # Avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # Lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # To avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            # Dim screen
            timeout = 150;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }

          {
            # Turn off keyboard backlight
            timeout = 150;
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "brightnessctl -rd rgb:kbd_backlight";
          }

          {
            # Lock screen
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }

          {
            # Turn off screen
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }

          {
            # Sleep
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

  };
}
