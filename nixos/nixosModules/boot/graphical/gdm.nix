{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.boot.graphical.gdm;
in
{
  options.nixosModules.boot.graphical.gdm = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.boot.graphical.enable;
      # default = false;
    };
  };

  config = mkIf cfg.enable {
    # stylix.targets.gdm.useWallpaper = false;
    # programs.gdm.settings.background.path = config.nixosModules.theming.wallpapers.secondary;

    services.displayManager.gdm = {
      enable = true;
      wayland = true;

      # Should be handled by systemd an other system services like tlp?
      autoSuspend = false;
    };
  };
}
