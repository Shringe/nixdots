{ config, lib, ... }:
{
  imports = [
    ./extra-plugins
    ./optimizations.nix
  ];

  programs.nixvim = lib.mkIf config.homeManagerModules.nixvim.enable {
    enable = true;
    colorschemes.catppuccin.enable = true;

    # Simple plugins
    plugins = {
      lualine.enable = true;
      nvim-autopairs.enable = true;
      web-devicons.enable = true;
      friendly-snippets.enable = true;
      nvim-surround.enable = true;
    };

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

    keymaps = [
      # {
      #   key = ";";
      #   action = ":";
      # }
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

