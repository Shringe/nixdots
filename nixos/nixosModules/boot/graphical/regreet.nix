{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.boot.graphical.regreet;

  swayConfig = pkgs.writeText "greetd-sway-config" ''
    exec "${pkgs.regreet}/bin/regreet; ${pkgs.sway}/bin/swaymsg exit"
    seat "*" xcursor_theme "${config.stylix.cursor.name}" ${toString config.stylix.cursor.size}

    input "*" {
      accel_profile flat
      pointer_accel -0.675
    }

    input type:touchpad {
      accel_profile adaptive
      pointer_accel 0.0
    }

    output "eDP-1" {
      mode 1920x1080@60Hz
      render_bit_depth 10
    }

    output "DP-1" {
      disable
    }

    output "HDMI-A-1" {
      mode 3440x1440@175Hz
      render_bit_depth 10
    }
  '';
in
{
  options.nixosModules.boot.graphical.regreet = {
    enable = mkOption {
      type = types.bool;
      # default = config.nixosModules.boot.graphical.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.regreet.useWallpaper = false;
    programs.regreet.settings.background.path = config.nixosModules.theming.wallpapers.secondary;

    services.greetd.settings.default_session.command =
      "${pkgs.sway}/bin/sway --unsupported-gpu --config ${swayConfig}";
    environment.etc."greetd/sway".source = swayConfig;

    programs.regreet.enable = true;
  };
}
