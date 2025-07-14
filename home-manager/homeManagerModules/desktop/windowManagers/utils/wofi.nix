{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.wofi;
in {
  options.homeManagerModules.desktop.windowManagers.utils.wofi = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.enable;
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.wofi.enable = false;

    home.packages = with pkgs; mkIf cfg.enable [
      wofi-emoji
      wofi-power-menu
    ];

    programs.wofi = mkIf cfg.enable {
      enable = true;

      settings = {
        allow_images = true;
        hide_scroll = true;
        normal_window = true;
        insensitive = true;
        width = 800;
        height = 650;
        no_actions = true;
      };

      style = with config.lib.stylix.colors.withHashtag; with config.stylix.opacity; ''
        @define-color accent  alpha(${base07}, ${toString desktop});
        @define-color txt     alpha(${base07}, ${toString desktop});
        @define-color bg      alpha(${base01}, ${toString desktop});
        @define-color bg2     alpha(${base00}, ${toString desktop});

        * {
            font-family: "JetBrains";
            font-size: 16px;
         }

         /* Window */
         window {
            margin: 0px;
            padding: 4px;
            # border-radius: 16px;
            background-color: @bg;
         }

         /* Inner Box */
         #inner-box {
            margin: 5px;
            padding: 10px;
            border: none;
            border-radius: 5px;
            background-color: @bg;
         }

         /* Outer Box */
         #outer-box {
            margin: 5px;
            padding: 10px;
            border: none;
            background-color: @bg;
            border-radius: 5px;
         }

         /* Scroll */
         #scroll {
            margin: 0px;
            padding: 10px;
            border: none;
         }

         /* Input */
         #input {
            margin: 5px;
            padding: 10px;
            border: none;
            color: @accent;
            background-color: @bg;
            border: 2px solid @accent;
         }

         /* Text */
         #text {
            margin: 5px;
            padding: 10px;
            border: none;
            color: @txt;
         }

         /* Selected Entry */
         #entry:selected {
           background-color: @bg;
           outline: 1px solid @accent;
         }

         #entry:selected #text {
            color: @txt;
         }
         image {
           margin-left: 10px;
         }
      '';
    };
  };
}
