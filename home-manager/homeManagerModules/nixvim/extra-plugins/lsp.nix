{
  programs.nixvim.plugins.lsp = {
    enable = true;
    inlayHints = true;
    servers = {
      ruff.enable = true;
      bashls.enable = true;
      nixd.enable = true;
    };
  };
}
