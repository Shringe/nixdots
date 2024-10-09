{
  programs.nixvim = {
    plugins.toggleterm.enable = true;
    keymaps = [
      {
        mode = [ "t" "n" ];
        key = "<leader>n";
        action = "<cmd>ToggleTerm fish<CR>";
      }
    ];
  };
}
