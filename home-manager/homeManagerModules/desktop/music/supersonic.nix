{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.music.supersonic;
in {
  options.homeManagerModules.desktop.music.supersonic = {
    enable = mkEnableOption "Supersonic";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      supersonic
    ];
  };
}
