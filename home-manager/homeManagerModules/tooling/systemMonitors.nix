{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.tooling.systemMonitors;
in
{
  programs = lib.mkIf cfg.enable {
    htop.enable = true;

    btop = {
      enable = true;
      settings = {
        vim_keys = true;
        log_level = "ERROR";
        shown_boxes = "proc";
      };
    };

    fastfetch = {
      enable = true;
    };
  };
}
