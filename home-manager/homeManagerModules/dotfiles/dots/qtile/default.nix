{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.homeManagerModules.wm.qtile.installDependencies {
    home.packages = [
      pkgs.picom
      pkgs.flameshot
      pkgs.ranger
      pkgs.alacritty
      pkgs.dunst
    ];
  };
}
