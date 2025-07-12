{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.nixosModules.boot.displayManagers.greetd; 
  swayConfig = pkgs.writeText "greetd-sway-config" ''
    exec "${pkgs.greetd.regreet}/bin/regreet; ${pkgs.sway}/bin/swaymsg exit"

    input "*" {
      accel_profile flat
      pointer_accel -0.675
    }

    output "eDP-1" {
      mode 1920x1080@60Hz
      pos 0 0
      render_bit_depth 10
    }

    output "DP-1" {
      disable
    }

    output "HDMI-A-1" {
      mode 3440x1440@175Hz
      pos 2560 0
      render_bit_depth 10
    }
  '';
in {
  config = mkIf cfg.enable {
    services.greetd.settings.default_session.command = "${pkgs.sway}/bin/sway --unsupported-gpu --config ${swayConfig}";

    programs.regreet = {
      enable = true;
    };

    environment.etc."greetd/sway".source = swayConfig;
  };
}
