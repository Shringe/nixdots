{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers = {
        ruff = {
          enable = true;
          settings = {

          };
        };
        pyright = {
          enable = true;
          settings = {
            pyright = {
              disableOrganizeImports = true;
            };
            python = {
              analysis = {
                ignore = [ "*" ];
              };
            };
          };
        };
        bashls.enable = true;
        nixd.enable = true;
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>a";
        # options.silent = true;
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
      }
    ];
  };
}
