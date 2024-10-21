{
  programs.nixvim = {
    plugins.toggleterm.enable = true;
    keymaps = [
      {
        mode = [ "t" "n" ];
        # key = "<leader>n";
        key = "<C-n>";
        action = "<cmd>ToggleTerm fish<CR>";
      }
    ];
  };
}
