{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.polkit;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.polkit = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.polkit-gnome = {
      enable = true;
    };
  };
}
