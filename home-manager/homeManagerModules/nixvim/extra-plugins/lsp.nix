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
                typeCheckingMode = "strict";
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
        # options.silent = true;
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
      }
    ];
  };
}
