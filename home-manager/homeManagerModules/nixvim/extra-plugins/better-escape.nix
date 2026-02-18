{
  # This removes the delay from nvim waiting for chords while typing
  programs.nixvim = {
    plugins.better-escape = {
      enable = true;

      settings = {
        default_mappings = false;

        mappings = {
          t.n."<ESC>" = "<C-\\><C-n>";
        };
      };
    };

    # keymaps = [
    #   {
    #     # Esc in terminal mode
    #     mode = "t";
    #     key = "n<ESC>";
    #     action = "<C-\\><C-n>";
    #     options.silent = true;
    #   }
    # ];
  };

}
