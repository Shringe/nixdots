{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; lib.mkIf config.homeManagerModules.desktop.office.libreoffice.enable [
    libreoffice
  ];
  # programs.libreoffice = lib.mkIf config.homeManagerModules.desktop.office.libreoffice.enable {
  #   enable = true;
  # };
}

