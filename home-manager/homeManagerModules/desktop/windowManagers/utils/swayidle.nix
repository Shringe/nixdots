{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.swayidle;

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
  options.homeManagerModules.desktop.windowManagers.utils.swayidle = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    suspend = mkOption {
      type = types.bool;
      default = true;
      description = "Whether or not to fully suspend (sleep) the device.";
    };

    dim = mkOption {
      type = types.bool;
      default = true;
      description = "Whether or not to dim the device.";
    };

    turnOffScreenCmd = mkOption {
      type = types.str;
      default = "${pkgs.wlopm}/bin/wlopm --off '*'";
      description = "The cmd to turn off the screen.";
    };

    turnOnScreenCmd = mkOption {
      type = types.str;
      default = "${pkgs.wlopm}/bin/wlopm --on '*'";
      description = "The cmd to turn on the screen.";
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
        {
          event = "before-sleep";
          command = lockCmd;
        }
        {
          event = "lock";
          command = lockCmd;
        }
      ];

      timeouts = [
        {
          timeout = 330;
          command = lockCmd;
        }
      ]
      ++ optionals cfg.suspend [
        {
          timeout = 360;
          # command = "${pkgs.systemdMinimal}/bin/systemctl suspend";
          command = "systemctl suspend";
        }
      ]
      ++ optionals (!cfg.suspend) [
        {
          timeout = 300;
          command = cfg.turnOffScreenCmd;
          resumeCommand = cfg.turnOnScreenCmd;
        }
      ]
      ++ optionals cfg.dim [
        {
          timeout = 180;
          command = "${toggleBacklights}/bin/toggleBacklights";
          resumeCommand = "${toggleBacklights}/bin/toggleBacklights";
        }
      ];
    };
  };
}
