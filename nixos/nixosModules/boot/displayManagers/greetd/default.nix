{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.nixosModules.boot.displayManagers.greetd; 
  swayConfig = pkgs.writeText "greetd-sway-config" ''
    exec "${pkgs.greetd.regreet}/bin/regreet; ${pkgs.swayfx}/bin/swaymsg exit"
    exec ${pkgs.mpvpaper}/bin/mpvpaper -p -o "no-audio loop --gpu-api=vulkan hwdec=auto" eDP-1 "${../../../../../assets/wallpapers/video/Luffy-On-The-Beach-One-Piece_1920x1080.mp4}";

    corner_radius 12
    blur enable
    blur_passes 8
    shadows enable

    gaps inner 3
    gaps top 1
    gaps bottom 1
    gaps left 1
    gaps right 1

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
      adaptive_sync no
      mode 2560x1440@165Hz
      pos 0 0
      render_bit_depth 10
    }

    output "HDMI-A-1" {
      adaptive_sync no
      allow_tearing yes
      mode 3440x1440@175Hz
      pos 2560 0
      render_bit_depth 10
    }
  '';
in {
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        vt = 2;
        default_session = {
          command = "${pkgs.swayfx}/bin/sway --unsupported-gpu --config ${swayConfig}";
        };
      };
    };

    programs.regreet = {
      enable = true;
    };

    # environment.etc."greetd/environments".text = ''
    #   sway
    #   fish
    #   bash
    # '';
  };
}
