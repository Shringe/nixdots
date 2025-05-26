local wezterm = require("wezterm")
local config = {}

config = {
  default_prog = { "/usr/bin/env", "fish" },

  font = wezterm.font("JetBrains Mono"),
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
