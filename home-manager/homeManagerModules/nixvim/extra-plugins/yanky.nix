{
  plugins.telescope.keymaps."<leader>fy" = "yank_history";
  plugins.yanky = {
    enable = true;
    enableTelescope = true;

    settings = {
      highlight = {
        on_put = true;
        on_rank = true;
        timer = 500;
      };

      preserve_cursor_position.enabled = true;
    };
  };
}
