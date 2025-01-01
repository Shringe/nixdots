{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.gaming.mangohud;
in
{
  programs.mangohud = lib.mkIf cfg.enable {
    enable = true;
    enableSessionWide = false;

    settings = {
      preset = 3;

      # no_display = true;
      toggle_hud = "Shift_L + F12";
    };
  };
}
