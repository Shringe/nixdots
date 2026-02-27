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
    ./extra.nix
    ./optimizations.nix
  ];

  stylix.targets.nixvim.enable = false;

  programs.nixvim = lib.mkIf config.homeManagerModules.nixvim.enable {
    enable = true;
    colorschemes.catppuccin.enable = true;
    # colorschemes.tokyonight.enable = true;

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

      # Misc
      termguicolors = true;
      scrolloff = 8;
    };

    globals = {
      mapleader = " ";
    };

    # vim.api.nvim_set_keymap(  't'  ,  '<Leader><ESC>'  ,  '<C-\\><C-n>'  ,  {noremap = true}  )
    keymaps = [
      {
        mode = "n";
        key = "<leader>i";
        options.silent = true;
        action = "<cmd>wincmd k<CR>";
      }
      {
        mode = "n";
        key = "<leader>e";
        options.silent = true;
        action = "<cmd>wincmd j<CR>";
      }
      {
        mode = "n";
        key = "<leader>n";
        options.silent = true;
        action = "<cmd>wincmd h<CR>";
      }
      {
        mode = "n";
        key = "<leader>o";
        options.silent = true;
        action = "<cmd>wincmd l<CR>";
      }

      # {
      #   mode = "n";
      #   key = "<leader>k";
      #   options.silent = true;
      #   action = "<cmd>wincmd k<CR>";
      # }
      # {
      #   mode = "n";
      #   key = "<leader>j";
      #   options.silent = true;
      #   action = "<cmd>wincmd j<CR>";
      # }
      # {
      #   mode = "n";
      #   key = "<leader>h";
      #   options.silent = true;
      #   action = "<cmd>wincmd h<CR>";
      # }
      # {
      #   mode = "n";
      #   key = "<leader>l";
      #   options.silent = true;
      #   action = "<cmd>wincmd l<CR>";
      # }
      #
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
