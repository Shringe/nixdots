{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.waybar;
in {
  imports = [
    ./colorful.nix
    ./matte.nix
    ./transparent.nix
  ];

  options.homeManagerModules.desktop.windowManagers.utils.waybar = {
    enable = mkEnableOption "Default waybar configuration";

    wm = mkOption {
      type = types.string;
      default = "sway";
    };
  };

  config = mkIf cfg.enable {
    homeManagerModules.desktop.windowManagers.utils.waybar = {
      colorful.enable = mkDefault true;
    };
  };
}
