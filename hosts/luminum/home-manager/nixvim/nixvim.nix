{ pkgs, ... }:
# let
#   nixvim = import (builtins.fetchGit {
#     url = "https://github.com/nix-community/nixvim";
#     # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
#     # ref = "nixos-24.05";
#   });
# in
{
  imports = [
    # inputs.nixvim.homeManagerModules.nixvim
    ./optimizations.nix
    ./extra-plugins
  ];


  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;

    plugins = {
      lualine.enable = true;
      nvim-autopairs.enable = true;
      web-devicons.enable = true;
    };

    opts = {
      # Numberlines
      number = true;

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
      {
        key = ";";
        action = ":";
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

