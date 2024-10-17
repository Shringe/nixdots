{ config, pkgs, ... }:

{
  imports = [
    ./nixvim/nixvim.nix
    ./qtile.nix
    ./scripts.nix

    ./dots
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "shringe";
  home.homeDirectory = "/home/shringe";


  browsers.default = true;
  shells.enable = true;

  home.stateVersion = "24.05"; # Please read the comment before changing.

  programs = {
    git = {
      enable = true;
      userName = "Shringe";
      userEmail = "dashingkoso@gmail.com";
      
      extraConfig = {
        credential.helper = "store";
        safe.directory = "/nixdots";
      };
    };
  };


  # The home.packages option allows you to install Nix packages into your
  # environment.
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    #neovim
    fish
    xclip
    alsa-firmware
    fzf
    haskellPackages.greenclip
    redshift
    bat
    eza
    git 
    atuin
    picom
    chromium
    qutebrowser
    btop
    font-awesome
    pavucontrol
    meslo-lgs-nf
    nh
  ];

  
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionPath = [ "/home/shringe/.config/home-manager/scripts" ];
  home.sessionVariables = {
    # EDITOR = "emacs";
    EDITOR = "nvim";
    FLAKE = "/nixdots";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
