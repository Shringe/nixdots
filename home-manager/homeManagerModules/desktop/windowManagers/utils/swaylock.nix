{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.swaylock;
in {
  options.homeManagerModules.desktop.windowManagers.utils.swaylock = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.enable;
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.swaylock.useWallpaper = false;
    programs.swaylock.settings.image = config.homeManagerModules.theming.wallpapers.secondary;

    programs.swaylock = {
      enable = true;

      # settings = {
      # };
    };
  };
}
