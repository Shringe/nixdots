{
  programs.nixvim.plugins.colorizer = {
    enable = true;

    settings = {
      user_default_options = {
        RGB      = true;  # #RGB hex codes
        RGBA     = true;  # #RGBA hex codes
        RRGGBB   = true;  # #RRGGBB hex codes
        RRGGBBAA = true;  # #RRGGBBAA hex codes
        AARRGGBB = true;  # 0xAARRGGBB hex codes
        rgb_fn   = true;  # CSS rgb() and rgba() functions
        hsl_fn   = true;  # CSS hsl() and hsla() functions
        css      = true;  # Enable all CSS *features*:
        css_fn   = true;  # Enable all CSS *functions*: rgb_fn, hsl_fn
        tailwind = true;  # Enable tailwind colors
      };
    };
  }; 
}
