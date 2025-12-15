{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.mpvpaper;
  targets = config.homeManagerModules.desktop.windowManagers.utils.systemd.waylandTargets;

  f =
    order:
    "${pkgs.mpvpaper}/bin/mpvpaper -p -o 'no-audio loop --gpu-api=vulkan hwdec=auto' ${order.display} ${order.wallpaper}";
  g = order: {
    Unit = {
      Description = "Mpvpaper video wallpaper for display a specific display.";
      After = mkForce targets;
      PartOf = mkForce targets;
    };
    Install = {
      WantedBy = mkForce targets;
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = (f order);
    };
  };
in
{
  options.homeManagerModules.desktop.windowManagers.utils.mpvpaper = {
    enable = mkEnableOption "Mpvpaper video wallpapers";

    primary = {
      enable = mkEnableOption "primary";
      display = mkOption {
        type = types.str;
        default = "HDMI-A-1";
      };

      wallpaper = mkOption {
        type = types.path;
        default = ../../../../../assets/wallpapers/video/Luffy-On-The-Beach-One-Piece_3440x1440.mp4;
      };
    };

    secondary = {
      enable = mkEnableOption "secondary";
      display = mkOption {
        type = types.str;
        default = "DP-1";
      };

      wallpaper = mkOption {
        type = types.path;
        default = ../../../../../assets/wallpapers/video/Luffy-On-The-Beach-One-Piece_2560x1440.mp4;
      };
    };

    laptop = {
      enable = mkEnableOption "laptop";
      display = mkOption {
        type = types.str;
        default = "eDP-1";
      };

      wallpaper = mkOption {
        type = types.path;
        default = ../../../../../assets/wallpapers/video/Luffy-On-The-Beach-One-Piece_1920x1080.mp4;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services = {
      mpvpaper_primary = mkIf cfg.primary.enable (g cfg.primary);
      mpvpaper_secondary = mkIf cfg.secondary.enable (g cfg.secondary);
      mpvpaper_laptop = mkIf cfg.laptop.enable (g cfg.laptop);
    };
  };
}
