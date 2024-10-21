{
  programs.nixvim.plugins.lsp = {
    enable = true;
    servers = {
      ruff.enable = true;
      bashls.enable = true;
      nixd.enable = true;
    };
  };
}
