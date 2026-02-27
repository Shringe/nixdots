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
      # key = "<Alt-w>";
      key = "<Alt-w>";
      action = "<cmd>WhichKey<CR>";
      options.silent = true;
    }
  ];
}
