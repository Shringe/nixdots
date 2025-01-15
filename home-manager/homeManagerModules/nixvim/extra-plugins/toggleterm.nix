{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;

      settings = {
        direction = "float";
        # size = 70;
      };
    };

    keymaps = [
      {
        mode = [ "t" "n" ];
        key = "<leader>tt";
        # key = "<C-n>";
        action = "<cmd>ToggleTerm fish<CR>";
      }
    ];
  };
}
