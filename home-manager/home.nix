{ config, pkgs, ... }:

{
  imports = [
    ./nixvim/nixvim.nix
    ./qtile.nix
    ./scripts.nix
    ./fish.nix
    # ./librewolf.nix
    ./is_generic_linux.nix
    ./firefox.nix
    ./dots
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "shringe";
  home.homeDirectory = "/home/shringe";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.shellAliases = {
    ls = "eza --group-directories-first --icons";
    pyclean = "find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete";
  };

  programs = {
    git = {
     enable = true;
     userName = "Shringe";
     userEmail = "dashingkoso@gmail.com";
     
     extraConfig = {
       credential.helper = "store";
     };
    };
    atuin.enable = true;
    bash.enable = true;
  };


  # The home.packages option allows you to install Nix packages into your
  # environment.
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    #neovim
    fish
    fzf
    bat
    eza
    git 
    atuin
    btop
    font-awesome
  ];

  
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionPath = [ "/home/shringe/.config/home-manager/scripts" ];
  home.sessionVariables = {
    # EDITOR = "emacs";
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
