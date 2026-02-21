{
  plugins.gitsigns = {
    enable = true;

    lazyLoad.settings = {
      event = [
        "BufReadPost"
        "BufNewFile"
      ];
    };
  };
}
