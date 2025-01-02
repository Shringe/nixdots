{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;

      settings = {
        # I have an ultrawide so it makes sense
        direction = "vertical";
        size = 70;
      };
    };

    keymaps = [
      {
        mode = [ "t" "n" ];
        key = "<leader>n";
        # key = "<C-n>";
        action = "<cmd>ToggleTerm fish<CR>";
      }
    ];
  };
}
