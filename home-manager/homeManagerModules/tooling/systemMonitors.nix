{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.tooling.systemMonitors;
in
{
  programs = lib.mkIf cfg.enable {
    htop.enable = true;
    btop.enable = true;
  };
}
