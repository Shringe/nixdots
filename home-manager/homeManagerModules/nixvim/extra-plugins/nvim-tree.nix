{
  programs.nixvim = {
    plugins.nvim-tree = {
      enable = true;
      actions = {
        openFile.quitOnOpen = true;
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
