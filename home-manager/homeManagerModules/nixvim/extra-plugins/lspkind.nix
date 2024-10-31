{
  # Pretties up nvim-cmp menu
  programs.nixvim.plugins.lspkind = {
    enable = true;
    cmp = {
      enable = true;
      menu = {
        buffer = "[Buffer]";
        nvim_lsp = "[LSP]";
        luasnip = "[Snippet]";
        nvim_lua = "[Lua]";
        latex_symbols = "[Latex]";
      };
    };
  };
}
