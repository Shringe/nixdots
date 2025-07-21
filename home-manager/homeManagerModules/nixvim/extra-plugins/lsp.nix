{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      inlayHints = true;

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
        fish_lsp.enable = true;
        nixd.enable = true;
        lua_ls.enable = true;
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>a";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
      }
      {
        mode = "n";
        key = "<leader>gd";
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
      }
      {
        mode = "n";
        key = "<leader>gr";
        action = "<cmd>lua vim.lsp.buf.references()<CR>";
      }
      {
        mode = "n";
        key = "<leader>gi";
        action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
      }
      {
        mode = "n";
        key = "<leader>gt";
        action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
      }
    ];
  };
}
