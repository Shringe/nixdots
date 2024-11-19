{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.desktop.office.pdf;
in
{
  # home.packages = with pkgs; lib.mkIf cfg.enable [
  home.packages = lib.mkIf cfg.enable (with pkgs; [
    zathura
  ]);
}
