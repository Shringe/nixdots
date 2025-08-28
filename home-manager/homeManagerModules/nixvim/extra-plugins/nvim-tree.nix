{
  programs.nixvim = {
    plugins.nvim-tree = {
      enable = true;
      settings.actions = {
        open_file.quit_on_open = true;
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>fm";
        action = "<cmd>NvimTreeToggle<CR>";
      }
    ];
  };
}
