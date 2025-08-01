{
  programs.nixvim = {
    plugins.blink-cmp = {
      enable = true;

      settings = {
        ghost_text.enabled = true;

        completion = {
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
