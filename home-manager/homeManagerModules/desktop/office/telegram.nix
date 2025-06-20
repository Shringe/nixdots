{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.office.telegram;
in {
  options.homeManagerModules.desktop.office.telegram = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.office.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      telegram-desktop
    ];
  };
}
