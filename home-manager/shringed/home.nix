{ pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "shringed";
  home.homeDirectory = "/home/shringed";

  homeManagerModules = {
    nixvim.enable = true;
    desktop = {
      browsers.enable = true;
      terminals.enable = true;
      office.enable = true;
    };
    shells.enable = true;
    scripts.enable = true;
    dotfiles.enable = true;
    sops.enable = true;
    wm.enable = true;
  };

  home.stateVersion = "24.05"; # Please read the comment before changing.

  programs = {
    git = {
      enable = true;
      userName = "Shringe";
      userEmail = "dashingkoso@gmail.com";
      
      extraConfig = {
        credential.helper = "store";
        safe.directory = [ "/nixdots" "/nixdots/.git" ];
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
    nh

    meslo-lgs-nf
    jetbrains-mono
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    FLAKE = "/nixdots";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
