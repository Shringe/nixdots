{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;

      settings = {
        direction = "float";
      };
    };

    keymaps = [
      {
        mode = [ "t" "n" ];
        key = "<leader>tt";
        action = "<cmd>ToggleTerm fish<CR>";
      }
    ];
  };
}
