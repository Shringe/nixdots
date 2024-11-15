local wezterm = require("wezterm")
local config = {}

config = {
  default_prog = { "/usr/bin/env", "fish" },

  font = wezterm.font("JetBrains Mono"),
  font_size = 16,
  enable_tab_bar = false,
  -- window_decorations
  window_background_opacity = 0.8,

  -- fixes rendering issues
  front_end = "WebGpu",

  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
}

return config
