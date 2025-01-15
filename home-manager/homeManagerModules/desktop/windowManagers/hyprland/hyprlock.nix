{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.hyprlock;
in
{
  # stylix.targets.hyprlock.enable = false;

  programs.hyprlock = lib.mkIf cfg.enable {
    enable = true;

    settings = {
      general = {
        grace = 5;
      };

      background = {
        blur_size = 12;
        blur_passes = 1;
      };

      # background = lib.mkOverride [
      #   {
      #     path = "${config.stylix.image}";
      #     blur_size = 12;
      #     blur_passes = 1;
      #   }
      # ];
    };
  };
}
