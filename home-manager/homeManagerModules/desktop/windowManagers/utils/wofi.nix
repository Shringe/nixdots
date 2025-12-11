{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.wofi;

  wofi-hyprswitch = pkgs.writers.writeNuBin "wofi-hyprswitch" { } ''
    def get_window_info [] {
      ${pkgs.hyprland}/bin/hyprctl clients
    }

    def select_window [] {
      ${pkgs.hyprland}/bin/hyprctl dispatch focuswindow $"pid:($in)" | ignore
    }

    def prompt_wofi [] {
      $in | str join "\n" | ${pkgs.wofi}/bin/wofi --show=dmenu
    }

    def parse_window_info [] {
      $in | lines | reduce --fold [] {|line, acc|
        if ($line | is-empty) {
          $acc
        } else if ($line | str starts-with "Window ") {
          let parts = $line | parse "Window {address} -> {info}:"
          $acc | append {
            address: $parts.address.0
            info: $parts.info.0
          }
        } else {
          let field = $line | parse "{key}: {value}"
          if ($field | is-empty) {
            $acc
          } else {
            $acc | update ($acc | length | $in - 1) {
              $in | insert ($field.key.0 | str trim) ($field.value.0 | str trim)
            }
          }
        }
      }
    }

    def main [--class_in_name] {
      let info = get_window_info | parse_window_info

      let table = $info | each {
        let name = if $class_in_name { 
          $"($in.class): ($in.info)"
        } else {
          $in.info 
        }

        {
          name: $name
          pid: $in.pid
        }
      }

      let chosen_name = $table | get name | prompt_wofi
      let chosen_pid = $table | where name == $chosen_name | first | get pid
      $chosen_pid | select_window
    }
  '';
in
{
  options.homeManagerModules.desktop.windowManagers.utils.wofi = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.enable;
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.wofi.enable = false;

    home.packages =
      with pkgs;
      mkIf cfg.enable [
        wofi-emoji
        wofi-power-menu
        wofi-hyprswitch
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

      style =
        with config.lib.stylix.colors.withHashtag;
        with config.stylix.opacity;
        ''
          @define-color accent  alpha(${base07}, 0.3);
          @define-color txt     alpha(${base07}, 0.3);
          @define-color bg      alpha(${base01}, 0.3);
          @define-color bg2     alpha(${base00}, 0.3);

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
