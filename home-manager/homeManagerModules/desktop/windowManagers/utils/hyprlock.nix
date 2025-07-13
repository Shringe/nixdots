{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.hyprlock;
in {
  options.homeManagerModules.desktop.windowManagers.utils.hyprlock = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.hyprlock.useWallpaper = false;
    programs.hyprlock.settings.image = config.homeManagerModules.theming.wallpapers.secondary;

    programs.hyprlock = {
      enable = true;

      # settings = {
      # };
    };
  };
}
