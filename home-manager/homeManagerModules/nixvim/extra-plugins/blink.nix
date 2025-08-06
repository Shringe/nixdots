{
  programs.nixvim = {
    plugins.blink-cmp = {
      enable = true;

      settings = {
        completion = {
          ghost_text.enabled = true;
          menu = {
            # Double the default dementions
            min_width = 20;
            max_height = 30;
          };
        };
      };
    };
  };
}
