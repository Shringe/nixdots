{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.tooling.systemMonitors;
in
{
  programs = lib.mkIf cfg.enable {
    htop.enable = true;
    cava.enable = true;
    fastfetch.enable = true;

    btop = {
      enable = true;
      settings = {
        vim_keys = true;
        log_level = "WARNING";
        shown_boxes = "proc";
      };
    };
  };
}
