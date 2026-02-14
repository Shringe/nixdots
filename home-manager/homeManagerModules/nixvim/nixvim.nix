{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
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
      nvim-autopairs.enable = true;
      web-devicons.enable = true;
      nvim-surround.enable = true;
      gitsigns.enable = true;
      which-key.enable = true;
      spectre.enable = true;
      zellij.enable = true;
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
      {
        # Associates .kbd(kanata config) files with lisp
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
      # shell = "fish";
      shell = config.homeManagerModules.shells.default;

      # Numberlines
      number = true;
      relativenumber = true;

      # Autoreload
      autoread = true;

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
      {
        # Esc in terminal mode
        mode = "t";
        key = "n<ESC>";
        action = "<C-\\><C-n>";
        options.silent = true;
      }

      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>WhichKey<CR>";
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

      {
        mode = "n";
        key = "<leader>ss";
        options.silent = true;
        action = "<cmd>write<CR>";
      }
      {
        mode = "n";
        key = "<leader>sa";
        options.silent = true;
        action = "<cmd>exit<CR>";
      }
      {
        mode = "n";
        key = "<leader>st";
        options.silent = true;
        action = "<cmd>bdelete<CR>";
      }
    ];
  };
}
