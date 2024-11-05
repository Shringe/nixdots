{
  programs.nixvim.plugins.none-ls = {
    enable = true;

    sources = {
      diagnostics = {
        mypy.enable = true;
      };
    };
  };
}
