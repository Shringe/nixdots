{
  programs.nixvim.plugins.lspkind = {
    enable = true;
    cmp = {
      enable = true;
      menu = {
        buffer = "[Buffer]";
        nvim_lsp = "[LSP]";
        luasnip = "[LuaSnip]";
        nvim_lua = "[Lua]";
        latex_symbols = "[Latex]";
      };
    };
  };
}
