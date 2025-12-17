{ pkgs, lib, ... }:
with lib;
{
  homeManagerModules = {
    tooling.enable = true;
    theming.enable = true;
    nixvim.enable = true;
    desktop = {
      enable = true;
      # discord.enable = true;
      kdeconnect.enable = true;
      music.enable = true;
      browsers.enable = true;
      browsers.chromium.enable = true;
      terminals.enable = true;
      terminals.alacritty.enable = true;
      office.enable = true;
      windowManagers = {
        enable = true;
        hyprland.uid = 1001;
        # hyprland.hyprpaper.enable = mkForce false;
        utils = {
          rot8.enable = true;
          wluma.enable = true;
          # mpvpaper = {
          #   enable = true;
          #   laptop.enable = true;
          # };
        };
      };
      email.enable = true;
    };

    shells.enable = true;
    # shells.atuin.enable = false;
    scripts.enable = true;
    dotfiles.enable = true;
    sops.enable = true;
    gaming.enable = true;
  };

  home.stateVersion = "24.05"; # Please read the comment before changing.

  programs = {
    git = {
      enable = true;

      settings = {
        user = {
          name = "Shringe";
          email = "dashingkoso@gmail.com";
        };

        credential.helper = "store";
        safe.directory = [
          "/nixdots"
          "/nixdots/.git"
        ];
      };
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    alsa-firmware
    fzf
    bat
    eza
    btop
    pavucontrol
    nh

    meslo-lgs-nf
    jetbrains-mono
    font-awesome
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    FLAKE = "/nixdots";

    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
  };
}
