{ pkgs, ... }:
{
  programs.nixvim.plugins.treesitter = {
    enable = true;

    settings = {
      highlight = {
        enable = true;
	additional_vim_regex_highlighting = true;
      };

      indent.enable = true;
    };

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
}
