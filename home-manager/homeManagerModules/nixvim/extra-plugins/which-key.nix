{
  plugins.which-key = {
    enable = true;

    lazyLoad.settings = {
      event = "UIEnter";
      cmd = "WhichKey";
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>WhichKey<CR>";
      options.silent = true;
    }
  ];
}
