{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.hyprlock;
in {
  options.homeManagerModules.desktop.windowManagers.utils.hyprlock = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # stylix.targets.hyprlock.useWallpaper = false;
    stylix.targets.hyprlock.enable = false;
    # programs.hyprlock.settings.image = config.homeManagerModules.theming.wallpapers.secondary;

    programs.hyprlock = {
      enable = true;

      # settings = {
      #   background = {
      #     path = toString config.homeManagerModules.theming.wallpapers.secondary;
      #     blur_passes = 1;
      #   };
      # };

      # The module seemed to generate config errors with some options
      extraConfig = with config.lib.stylix.colors; ''
        general {
          hide_cursor = false
          grace = 0
        }

        background {
          monitor =
          path = ${config.homeManagerModules.theming.wallpapers.secondary}
          blur_passes = 1
        }

        # -- time --
        label {
          monitor =
          text = cmd[update:1000] echo "$(date +"%H:%M")"
          color = rgb(${base07})
          font_size = 80
          font_family = JetBrains Mono ExtraBold
          position = 0, 200
          halign = center
          valign = center
        }

        # -- quote --
        label {
          monitor =
          text = - PAIN IS REAL, BUT SO IS HOPE -
          color = rgb(${base06})
          font_size = 12
          font_family = JetBrains Mono ExtraLight
          position = 0, 80
          halign = center
          valign = center
        }

        # -- greeting --
        label {
          monitor =
          text = Heya $USER :3
          color = rgb(${base07})
          font_size = 20
          font_family = JetBrains Mono Light
          position = 0, 0
          halign = center
          valign = center
        }

        # -- password input --
        input-field {
          monitor =
          size = 230, 40
          outline_thickness = 0
          dots_size = 0.2 
          dots_spacing = 0.4 
          dots_center = true
          inner_color = rgb(${base01})
          font_color = rgb(${base07})
          fade_on_empty = false
          placeholder_text = <span foreground='white'><i>unlock the magic...</i></span> 
          fail_color = rgb(${base07})
          hide_input = false
          position = 0, -50
          halign = center
          valign = center
        }
      '';
    };
  };
}
