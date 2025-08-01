{ config, lib, ... }:
{
  imports = [
    ./extra-plugins
    ./optimizations.nix
    ./extra.nix
  ];

  stylix.targets.nixvim.enable = false;

  programs.nixvim = lib.mkIf config.homeManagerModules.nixvim.enable {
    enable = true;
    colorschemes.catppuccin.enable = true;
    # colorschemes.tokyonight.enable = true;

    # Simple plugins
    plugins = {
      lualine.enable = true;
      nvim-autopairs.enable = true;
      web-devicons.enable = true;
      nvim-surround.enable = true;
      gitsigns.enable = true;
      which-key.enable = true;
      render-markdown.enable = true;
    };

    autoCmd = [
      # { # Makes _ a valid wordbreak in rust
      #   command = "set iskeyword-=_";
      #   event = [
      #     "BufNewFile"
      #     "BufRead"
      #   ];
      #   pattern = [
      #     "*.rs"
      #   ];
      # }
      { # Associates .kbd(kanata config) files with lisp
        command = "setfiletype lisp";
        event = [
          "BufNewFile"
          "BufRead"
        ];
        pattern = [
          "*.kbd"
        ];
      }
    ];

    opts = {
      shell = "fish";

      # Numberlines
      number = true; 
      relativenumber = true; 

      # Saves undo history to swapfile
      undofile = true;

      # 2 spaces for tab
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      softtabstop = 2;
    };

    globals = {
      mapleader = " ";
    };

# vim.api.nvim_set_keymap(  't'  ,  '<Leader><ESC>'  ,  '<C-\\><C-n>'  ,  {noremap = true}  )
    keymaps = [
      {# Esc in terminal mode
        mode = "t";
        key = "<ESC>";
        action = "<C-\\><C-n>";
        options.silent = true;
      }

      {
        mode = "n";
        key = "<leader><Up>";
        options.silent = true;
        action = "<cmd>wincmd k<CR>";
      }
      {
        mode = "n";
        key = "<leader><Down>";
        options.silent = true;
        action = "<cmd>wincmd j<CR>";
      }
      {
        mode = "n";
        key = "<leader><Left>";
        options.silent = true;
        action = "<cmd>wincmd h<CR>";
      }
      {
        mode = "n";
        key = "<leader><Right>";
        options.silent = true;
        action = "<cmd>wincmd l<CR>";
      }

      {
        mode = "n";
        key = "<leader>k";
        options.silent = true;
        action = "<cmd>wincmd k<CR>";
      }
      {
        mode = "n";
        key = "<leader>j";
        options.silent = true;
        action = "<cmd>wincmd j<CR>";
      }
      {
        mode = "n";
        key = "<leader>h";
        options.silent = true;
        action = "<cmd>wincmd h<CR>";
      }
      {
        mode = "n";
        key = "<leader>l";
        options.silent = true;
        action = "<cmd>wincmd l<CR>";
      }
    ];
  };
}

