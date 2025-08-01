{
  programs.nixvim.plugins.none-ls = {
    enable = false;
    sources = {
      diagnostics = {
        mypy.enable = true;

      };
    };
  };
}
