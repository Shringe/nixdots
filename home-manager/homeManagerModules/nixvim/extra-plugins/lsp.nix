{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      inlayHints = true;

      servers = {
        ruff = {
          enable = true;

        };

        basedpyright = {
          enable = true;
          settings = {
            python.analysis.ignore = [ "*" ];

            basedpyright = {
              disableOrganizeImports = true;
              disableTaggedHints = true;

              analysis = {
                typeCheckingMode = "basic";
                inlayHints = {
                  variableTypes = true;
                  functionReturnTypes = true;
                  callArgumentNames = "partial";
                  pytestParameters = true;
                  genericTypes = true;
                  declarationTypes = true;
                  assignmentTypes = true;
                };
              };
            };
          };
        };

        # jedi_language_server = {
        #   enable = true;
        # };

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
        # nushell.enable = true;
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
      {
        mode = "n";
        key = "<leader>rn";
        action = "<cmd>lua vim.lsp.buf.rename()<CR>";
      }
    ];
  };
}
