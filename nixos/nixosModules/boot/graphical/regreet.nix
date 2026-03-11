{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.boot.graphical.regreet;

  # hyprland-config = pkgs.writeText "hyprland-config" ''
  #   misc {
  #     disable_hyprland_logo = true
  #     disable_splash_rendering = true
  #     disable_hyprland_guiutils_check = true
  #     disable_autoreload = true
  #   }
  #
  #   monitorv2 {
  #     output = eDP-1
  #     bitdepth = 10
  #     mode = 1920x1080@60
  #     position = 0x0
  #     scale = 1
  #     vrr = 0
  #   }
  #
  #   monitorv2 {
  #     output = DP-1
  #     disabled = true
  #     bitdepth = 10
  #     mode = 2560x1440@165
  #     position = auto-left
  #     scale = 1
  #     vrr = 1
  #   }
  #
  #   monitorv2 {
  #     output = HDMI-A-1
  #     bitdepth = 10
  #     mode = 3440x1440@175
  #     position = 0x0
  #     scale = 1
  #     vrr = 1
  #   }
  #
  #   device {
  #     name = msft0001:01-04f3:3138-touchpad
  #     sensitivity = 0.000000
  #   }
  #
  #   input {
  #     accel_profile = flat
  #     follow_mouse = true
  #     repeat_delay = 500
  #     repeat_rate = 30
  #     sensitivity = -0.675000
  #   }
  #
  #   env = GTK_USE_PORTAL,0
  #   env = GDK_DEBUG,no-portals
  #
  #   exec-once = ${pkgs.regreet}/bin/regreet; hyprctl dispatch exit
  #   exec-once = hyprctl setcursor "${config.stylix.cursor.name}" ${toString config.stylix.cursor.size}
  # '';

  niri-config = pkgs.writeText "niri-config" ''
    hotkey-overlay {
      skip-at-startup
    }

    environment {
      GTK_USE_PORTAL "0"
      GDK_DEBUG "no-portals"
    }

    cursor {
      xcursor-theme "${config.stylix.cursor.name}"
      xcursor-size ${toString config.stylix.cursor.size}
    }

    layout {
      background-color "#000000"
    }

    input {
      keyboard {
        repeat-delay 500
        repeat-rate 30
      }

      touchpad {
        accel-speed 0.0
        disabled-on-external-mouse
      }

      mouse {
        accel-speed -0.675
        accel-profile "flat"
      }

      disable-power-key-handling
    }

    output "eDP-1" {
      mode "1920x1080@60"
    }

    output "DP-1" {
      off
    }

    output "HDMI-A-1" {
      mode "3440x1440@174.962"
    }

    binds {

    }

    spawn-sh-at-startup "${pkgs.regreet}/bin/regreet; ${pkgs.coreutils}/bin/sleep 0.5; ${pkgs.niri}/bin/niri msg action quit --skip-confirmation"
  '';
in
{
  options.nixosModules.boot.graphical.regreet = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.boot.graphical.enable;
      # default = false;
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.regreet.useWallpaper = false;
    programs.regreet.settings.background.path = config.nixosModules.theming.wallpapers.secondary;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.niri}/bin/niri --config ${niri-config}";
          # command = "/run/current-system/sw/bin/start-hyprland -- --config ${hyprland-config}";
          user = "greeter";
        };
      };
    };

    programs.regreet.enable = true;
  };
}
