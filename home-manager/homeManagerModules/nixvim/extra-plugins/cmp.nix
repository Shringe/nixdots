{
  programs.nixvim.plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings.sources = [
      { name = "nvim_lsp"; }
      { name = "luasnip"; }
      { name = "async_path"; }
    ];
  };
}
