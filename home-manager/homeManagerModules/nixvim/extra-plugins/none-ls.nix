{
  plugins.none-ls = {
    enable = true;
    sources = {
      diagnostics = {
        # mypy.enable = true;
        # qmllint.enable = true;
      };

      formatting = {
        qmlformat.enable = true;
      };
    };
  };
}
