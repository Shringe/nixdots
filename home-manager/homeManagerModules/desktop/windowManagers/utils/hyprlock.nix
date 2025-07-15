{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.hyprlock;

  mediaWidget = pkgs.writers.writeNuBin "mediaWidget" ''
    def format [artist: string, album: string, title: string, length: string, music_volume: string, system_volume: string, status: string] {
      print $"Artist: ($artist)"
      print $"Album:  ($album)"
      print $"Title:  ($title)"
      print $"Length: ($length)"
      print ""
      print $"Music:  ($music_volume)"
      print $"System: ($system_volume)"
      print $"Status: ($status)"
    }

    let data = (${pkgs.playerctl}/bin/playerctl metadata --format "{{artist}};{{album}};{{title}};{{duration(mpris:length)}};{{status}};{{volume}}")
    let metadata_array = ($data | split row ";")
    let system_volume = (${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | str replace "Volume: " "" | into float | $in * 100 | math round)

    # Convert music volume to percentage and format
    let music_volume_percent = ($metadata_array | get 5 | into float | $in * 100 | math round)

    # Call the format function with the parsed data
    format ($metadata_array | get 0) ($metadata_array | get 1) ($metadata_array | get 2) ($metadata_array | get 3) $"($music_volume_percent)%" $"($system_volume)%" ($metadata_array | get 4)
  '';
in {
  options.homeManagerModules.desktop.windowManagers.utils.hyprlock = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.hyprlock.enable = false;

    programs.hyprlock = {
      enable = true;

      # The module seemed to generate config errors with some options
      extraConfig = with config.lib.stylix.colors; ''
        # GENERAL
        general {
          hide_cursor = true
          ignore_empty_input = true
        }

        # BACKGROUND
        background {
          monitor = 
          path = ${config.homeManagerModules.theming.wallpapers.secondary}
          blur_passes = 2
        }

        # -- time --
        label {
          monitor =
          text = cmd[update:15000] ${pkgs.coreutils}/bin/echo "$(${pkgs.coreutils}/bin/date +"%H:%M")"
          color = rgb(${base07})
          font_size = 80
          font_family = JetBrains Mono ExtraBold
          position = 0, 100
          halign = center
          valign = center
        }

        # Album Art
        image {
          monitor =
          path = 
          size = 300
          rounding = 10
          border_size = 0
          reload_time = 2
          reload_cmd = ${pkgs.playerctl}/bin/playerctl metadata mpris:artUrl
          position = -190, -220
          halign = center
          valign = center
        }

        # Media Paragraph
        label {
          monitor = 
          text = cmd[update:100] ${mediaWidget}/bin/mediaWidget
          font_size = 20
          # font_family = JetBrains Mono Nerd Font Mono 
          font_family = JetBrains Mono Nerd Font Mono ExtraBold
          color = rgb(${base07})
          position = 49%, -220
          halign = none
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

        input-field {
          monitor =
          size = 300, 60
          outline_thickness = 4
          dots_size = 0.2 
          dots_spacing = 0.4 
          dots_center = true
          inner_color = rgb(${base01})
          font_color  = rgb(${base07})
          fail_color  = rgb(${base08})
          check_color = rgb(${base0A})
          fade_on_empty = false
          placeholder_text =  $USER
          hide_input = false
          position = 0, -470
          halign = center
          valign = center
        }
      '';
    };
  };
}
