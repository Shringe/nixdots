{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl.waybar;
in {
  imports = [
    ./colorful.nix
  ];

  options.homeManagerModules.desktop.windowManagers.dwl.waybar = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.dwl.enable;
    };

    variant = mkOption {
      type = types.enum [ "colorful" ];
      default = "colorful";
    };
  };
}
