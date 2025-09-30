{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.hypridle;

  lockCmd = "${pkgs.procps}/bin/pgrep hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
  toggleBacklights = pkgs.writeShellApplication {
    name = "toggleBacklights";
    runtimeInputs = with pkgs; [
      coreutils
      brightnessctl
    ];

    text = ''
      lock="/tmp/toggleBacklights.state"
      kbd="platform::kbd_backlight"
      if [ -f "$lock" ]; then
          read -r screenMode kbdMode < "$lock"
          rm "$lock"
          brightnessctl set "$screenMode"
          brightnessctl --device "$kbd" set "$kbdMode"
      else
          screenMode=$(brightnessctl get)
          kbdMode=$(brightnessctl --device "$kbd" get)
          echo "$screenMode $kbdMode" > "$lock"
          brightnessctl set 20%
          brightnessctl --device "$kbd" set 0
      fi
    '';
  };
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
          lock_cmd = lockCmd; # Avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # Lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # To avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            # Dim backlights
            timeout = 180;
            on-timeout = "${toggleBacklights}/bin/toggleBacklights";
            on-resume = "${toggleBacklights}/bin/toggleBacklights";
          }

          {
            # Lock screen
            timeout = 300;
            on-timeout = lockCmd;
          }

          {
            # Turn off screen
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
