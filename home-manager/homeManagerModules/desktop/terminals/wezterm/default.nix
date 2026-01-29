{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.terminals.wezterm;
in
{
  programs.wezterm = lib.mkIf cfg.enable {
    enable = true;
    # unstable wezterm is currently broken at the time of making this
    # package = pkgs-stable.wezterm;

    # extraConfig = builtins.readFile ./wezterm.lua;

    extraConfig = ''
      local wezterm = require("wezterm")
      local config = {}

      config = {
        -- default_prog = { "/usr/bin/env", "fish", "-C", "fastfetch" },
        default_prog = { "/usr/bin/env", "${config.homeManagerModules.shells.default}", "--execute", "fastfetch" },

        font = wezterm.font("JetBrainsMono Nerd Font"),
        -- font_size = 16,
        enable_tab_bar = false,
        -- window_decorations
        -- window_background_opacity = 0.8,

        window_padding = {
          left = 2,
          right = 2,
          top = 2,
          bottom = 2,
        },
      }

      return config
    '';
  };
}
