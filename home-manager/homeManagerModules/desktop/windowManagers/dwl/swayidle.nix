{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl.swayidle;

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
  options.homeManagerModules.desktop.windowManagers.dwl.swayidle = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.dwl.enable;
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
          timeout = 300;
          command = lockCmd;
        }
      ]
      ++ optionals cfg.suspend [
        {
          timeout = 330;
          command = "${pkgs.systemdMinimal}/bin/systemctl suspend";
        }
      ]
      ++ optionals (!cfg.suspend) [
        {
          timeout = 330;
          command = "${pkgs.wlopm}/bin/wlopm --off '*'";
          resumeCommand = "${pkgs.wlopm}/bin/wlopm --on '*'";
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
