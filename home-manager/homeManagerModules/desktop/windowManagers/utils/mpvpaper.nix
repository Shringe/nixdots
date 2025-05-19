{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.mpvpaper;

  f = order: "${pkgs.mpvpaper}/bin/mpvpaper -p -o 'no-audio loop --gpu-api=vulkan hwdec=auto' ${order.display} ${order.wallpaper}";
  g = order: {
    Unit = {
      Description = "Mpvpaper video wallpaper for display a specific display.";
    };
    Install = {
      WantedBy = [ "sway-session.target" ];
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = (f order);
      Restart = "on-failure";
      RestartSec = "3s";
    };
  };
in {
  options.homeManagerModules.desktop.windowManagers.utils.mpvpaper = {
    enable = mkEnableOption "Mpvpaper video wallpapers";

    primary = {
      display = mkOption {
        type = types.str;
        default = "HDMI-A-1";
      };

      wallpaper = mkOption {
        type = types.path;
        default = ../../../../../assets/wallpapers/video/Luffy-On-The-Beach-One-Piece_3440x1440.mp4;
      };
    };

    secondaryHorizontal = {
      display = mkOption {
        type = types.str;
        default = "DP-1";
      };

      wallpaper = mkOption {
        type = types.path;
        default = ../../../../../assets/wallpapers/video/Luffy-On-The-Beach-One-Piece_2560x1440.mp4;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services = {
      primary_mpvpaper = (g cfg.primary);
      secondaryHorizontal_mpvpaper = (g cfg.secondaryHorizontal);
    };
  };
}
