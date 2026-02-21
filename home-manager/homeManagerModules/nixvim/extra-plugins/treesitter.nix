{ pkgs, ... }:
{
  plugins = {
    treesitter = {
      enable = true;

      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = true;
        };

        indent.enable = true;
        folding.enable = true;

        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          json
          lua
          make
          markdown
          nix
          regex
          toml
          vim
          vimdoc
          xml
          yaml

          python
          rust
        ];
      };
    };

    treesitter-textobjects = {
      enable = true;

      settings.select = {
        enable = true;

        keymaps = {
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@class.outer";
          "ic" = {
            query_group = "@class.inner";
            desc = "Select inner part of a class region";
          };
        };
      };
    };
  };
}
