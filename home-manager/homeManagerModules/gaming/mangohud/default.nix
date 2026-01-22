{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.gaming.mangohud;
in
{
  options.homeManagerModules.gaming.mangohud = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.gaming.enable;
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.mangohud.enable = false;

    programs.mangohud = {
      enable = true;
      enableSessionWide = false;

      settings = {
        # preset = 4;
        fps_value = "60,175";
        full = true;
        no_display = true;
        toggle_hud = "Shift_L + F12";
        gpu_list = [ 1 ];
        font_size = 20;
      };
    };
  };
}
