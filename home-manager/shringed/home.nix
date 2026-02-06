{ pkgs, lib, ... }:
with lib;
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
        hyprland.uid = 1000;
        hyprland.monitors = {
          primary = "HDMI-A-1";
          secondary = "DP-1";
        };
        hyprland.plugins.enable = true;

        utils = {
          swayidle.suspend = false;
          openrgb.enable = true;
          wluma.enable = mkForce false;
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
    gaming.recording.enable = true;
  };

  programs.neovide.settings.vsync = false;
  programs.nixvim.globals = {
    neovide_refresh_rate = 175;
  };

  stylix.targets.hyprpaper.enable = mkForce false;
  services.hyprpaper.settings =
    let
      wall = toString ../../assets/wallpapers/2b_nier_automata_2560x1440.png;
      wall2 = toString ../../assets/wallpapers/grassmastersword_3440x1440.png;
    in
    {
      preload = [
        wall
        wall2
      ];

      wallpaper = [
        "DP-1,${wall}"
        "HDMI-A-1,${wall2}"
      ];
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

  systemd.user.services.set-primary-display = {
    Unit = {
      Description = "Set primary X display to HDMI-A-2";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      ConditionEnvironment = "DISPLAY";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-A-2 --primary";
      RemainAfterExit = true;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

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
    dotnet-sdk_8
    sysbench
    stress
    fzf
    git
    btop
    nh
    meslo-lgs-nf
    jetbrains-mono
    font-awesome
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
