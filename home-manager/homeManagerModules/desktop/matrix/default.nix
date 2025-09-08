{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.matrix;
in
{
  options.homeManagerModules.desktop.matrix = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    programs = {
      element-desktop.enable = true;
      nheko.enable = true;
    };
  };
}
