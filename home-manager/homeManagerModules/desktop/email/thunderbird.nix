{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.desktop.email.thunderbird;
in
{
  home.packages = with pkgs; lib.mkIf cfg.enable [
    thunderbird
  ];
}
