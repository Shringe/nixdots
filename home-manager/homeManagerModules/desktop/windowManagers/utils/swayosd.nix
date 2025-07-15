{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.swayosd;
in {
  options.homeManagerModules.desktop.windowManagers.utils.swayosd = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.swayosd = {
      enable = true;
    };
  };
}
