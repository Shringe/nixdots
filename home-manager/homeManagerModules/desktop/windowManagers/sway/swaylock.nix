{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.sway.swaylock;
in {
  options.homeManagerModules.desktop.windowManagers.sway.swaylock = {
    enable = mkEnableOption "swaylock";
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
