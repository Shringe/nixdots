{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.office.feh;
in {
  options.homeManagerModules.desktop.office.feh = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.office.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.feh = {
      enable = true;
    };
  };
}
