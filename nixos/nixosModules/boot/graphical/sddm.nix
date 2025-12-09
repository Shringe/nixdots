{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.boot.graphical.sddm;
in
{
  options.nixosModules.boot.graphical.sddm = {
    enable = mkOption {
      type = types.bool;
      # default = config.nixosModules.boot.graphical.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # stylix.targets.sddm.useWallpaper = false;
    # programs.sddm.settings.background.path = config.nixosModules.theming.wallpapers.secondary;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
