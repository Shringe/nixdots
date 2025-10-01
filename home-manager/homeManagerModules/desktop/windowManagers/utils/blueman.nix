{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.blueman;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.blueman = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.blueman-applet.enable = true;
  };
}
