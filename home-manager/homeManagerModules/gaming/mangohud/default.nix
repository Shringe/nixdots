{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.gaming.mangohud;
in
{
  config = mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      enableSessionWide = false;

      settings = {
        # preset = 4;
        fps_value = "60,175";
        full = true;
        no_display = true;
        toggle_hud = "Shift_L + F12";
      };
    };
  };
}
