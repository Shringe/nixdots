{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.hyprlock;
in
{
  programs.hyprlock = lib.mkIf cfg.enable {
    enable = true;

    settings = {
      general = {
        grace = 5;
        no_fade_in = false;
        disable_loading_bar = true;
      };

      background = {
        blur_passes = 2;
        blur_size = 12;
      };

      input-field = {
        size = "250, 60";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        fade_on_empty = false;
        font_family = "JetBrains Mono Nerd Font Mono";
        placeholder_text = "Input Password...";
        hide_input = false;
        position = "0, -120";
        halign = "center";
        valign = "center";
      };

      label = [
        {
          text = "cmd[update:1000] echo \"$(date +\"%-I:%M%p\")\"";
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_size = 120;
          font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          position = "0, -300";
          halign = "center";
          valign = "top";
        }
        {
          text = "Hello, $USER.";
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_size = 25;
          font_family = "JetBrains Mono Nerd Font Mono";
          position = "0, -40";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
