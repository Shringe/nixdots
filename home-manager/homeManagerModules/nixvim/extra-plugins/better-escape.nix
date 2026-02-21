{ ifNotEnabled, ... }:
{
  # This removes the delay from nvim waiting for chords while typing
  plugins.better-escape = {
    enable = false;

    settings = {
      default_mappings = false;

      mappings = {
        t.n."<ESC>" = "<C-\\><C-n>";
      };
    };
  };

  keymaps = ifNotEnabled [
    {
      # Esc in terminal mode
      mode = "t";
      key = "n<ESC>";
      action = "<C-\\><C-n>";
      options.silent = true;
    }
  ];
}
