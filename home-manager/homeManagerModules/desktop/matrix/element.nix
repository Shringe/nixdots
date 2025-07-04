{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.matrix.element;
in {
  options.homeManagerModules.desktop.matrix.element = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.matrix.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      element-desktop
    ];
  };
}
