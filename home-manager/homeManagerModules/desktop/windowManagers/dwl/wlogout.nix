{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl.wlogout;
in {
  options.homeManagerModules.desktop.windowManagers.dwl.wlogout = {
    enable = mkOption {
      type = types.bool;
      # default = config.homeManagerModules.desktop.windowManagers.dwl.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.wlogout = {
      enable = true;
    };
  };
}
