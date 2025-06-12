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
    programs.swaylock = {
      enable = true;

      # settings = {
      #
      # };
    };
  };
}
