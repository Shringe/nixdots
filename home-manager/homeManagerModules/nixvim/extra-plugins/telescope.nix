{ pkgs, ... }:
{
  home.packages = [ pkgs.ripgrep ];
  programs.nixvim = {
    # keymaps = [
    #   {# Delete current buffer with control d in buffer mode
    #     mode = "i";
    #     key = "<c-d>";
    #     action = "require('telescope.actions').delete_buffer";
    #   }
    # ];

    plugins.telescope = {
      enable = true;

      keymaps = {
        # Find files using Telescope command-line sugar.
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>fu" = "buffers";
        "<leader>fd" = "diagnostics";

        # "<c-d>" = {
        #   mode = "i";
        #   # action = "delete_buffer";
        #   action = "require('telescope.actions').delete_buffer";
        # };
      };

      settings = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        set_env.COLORTERM = "truecolor";
      };
    };
  };
}

