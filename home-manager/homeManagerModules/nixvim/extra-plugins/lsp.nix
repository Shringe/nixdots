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
        jedi_language_server = {
          enable = true;
        };
        # pyright = {
        #   enable = true;
        #   settings = {
        #     pyright = {
        #       disableOrganizeImports = true;
        #     };
        #     python = {
        #       analysis = {
        #         ignore = [ "*" ];
        #       };
        #     };
        #   };
        # };
        bashls.enable = true;
        nixd.enable = true;
        lua_ls.enable = true;
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
