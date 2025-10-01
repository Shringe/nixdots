{ pkgs, ... }:

{
  homeManagerModules = {
    theming = {
      enable = true;
      wallpapers = {
        primary = ./../../assets/wallpapers/PurpleFluid_3440x1440.png;
        secondary = ./../../assets/wallpapers/BlossomsCatppuccin_3440x1440.png;
      };
    };

    tooling.enable = true;
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
        utils.swayidle.suspend = false;
        utils.openrgb.enable = true;
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
      userName = "Shringe";
      userEmail = "dashingkoso@gmail.com";

      extraConfig = {
        credential.helper = "store";
        safe.directory = [
          "/nixdots"
          "/nixdots/.git"
        ];
      };
    };
  };
  #
  # xdg.configFile."openvr/openvrpaths.vrpath".text = ''
  #   {
  #     "config" :
  #     [
  #       "~/.local/share/Steam/config"
  #     ],
  #     "external_drivers" : null,
  #     "jsonid" : "vrpathreg",
  #     "log" :
  #     [
  #       "~/.local/share/Steam/logs"
  #     ],
  #     "runtime" :
  #     [
  #       "${pkgs.opencomposite}/lib/opencomposite"
  #     ],
  #     "version" : 1
  #   }
  # '';

  # The home.packages option allows you to install Nix packages into your
  # environment.
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    #neovim
    protonup
    fish
    xclip
    alsa-firmware
    fzf
    haskellPackages.greenclip
    redshift
    git
    atuin
    picom
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

    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    LIBVA_DRIVER_NAME = "nvidia";

    # GDK_BACKEND = "wayland,x11";
    # QT_QPA_PLATFORM = "wayland;xcb";
    # #SDL_VIDEODRIVER = "x11";
    # CLUTTER_BACKEND = "wayland";
    # XDG_CURRENT_DESKTOP = "Hyprland";
    # XDG_SESSION_TYPE = "wayland";
    # XDG_SESSION_DESKTOP = "Hyprland";
    # WLR_NO_HARDWARE_CURSORS = "1";
  };
}
