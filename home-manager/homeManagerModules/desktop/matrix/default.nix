{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.matrix;
in {
  imports = [
    ./element.nix
  ];

  options.homeManagerModules.desktop.matrix = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.enable; 
    };
  };
}
