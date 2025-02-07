{ lib, config, ... }:
{
  imports = [
    ./desktop
    ./shells
    ./dotfiles
    ./nixvim
    ./scripts
    ./sops
    ./gaming
    ./theming
    ./tooling
  ];

  # Defines all options for homeManagerModules
  options.homeManagerModules = {
    tooling = {
      enable = lib.mkEnableOption "Enable all";
      systemMonitors.enable = lib.mkEnableOption "systemMonitors";
    };

    theming = {
      enable = lib.mkEnableOption "enable theming";

      wallpaper = lib.mkOption {
        type = lib.types.str;
        default = "catppuccin_tux_3840x2160.png";
      };

      stylix = {
        enable = lib.mkEnableOption "Enable theming with stylix";
        colorScheme = lib.mkOption {
          type = lib.types.str;
          default = "catppuccin-mocha";
          description = "What .yaml theme to use.";
        };
      };
    };

    gaming = {
      enable = lib.mkEnableOption "All gaming settings";
      mangohud.enable = lib.mkEnableOption "Mangohud configuration";
    };

    sops = {
      enable = lib.mkEnableOption "Generate sops keys";
    };

    scripts = {
      enable = lib.mkEnableOption "packages shell scriptss";
    };

    nixvim = {
      enable = lib.mkEnableOption "Nixvim configuration";
      optimizations = lib.mkEnableOption "Applies expiremental performance optimizations";
    };

    desktop = {
      email = {
        enable = lib.mkEnableOption "Email setup";
        thunderbird.enable = lib.mkEnableOption "Thunderbird";
      };

      windowManagers = {
        enable = lib.mkEnableOption "Preferred window manager";
        qtile.enable = lib.mkEnableOption "qtile";
        hyprland = {
          enable = lib.mkEnableOption "Hyprland configuration";
          hyprpaper.enable = lib.mkEnableOption "hyprpaper configuration";
          wofi.enable = lib.mkEnableOption "Wofi configuration";
          waybar.enable = lib.mkEnableOption "Waybar configuration";
          swaync.enable = lib.mkEnableOption "Swaync configuration";
          hyprlock.enable = lib.mkEnableOption "hyprlock configuration";
          cliphist.enable = lib.mkEnableOption "cliphist configuration";
          hypridle.enable = lib.mkEnableOption "hypridle configuration";
        };
      };

      terminals = {
        enable = lib.mkEnableOption "Default terminal";
        ghostty.enable = lib.mkEnableOption "Ghostty config";
        wezterm.enable = lib.mkEnableOption "Wezterm configuration";
        alacritty.enable = lib.mkEnableOption "Alacritty configuration";
      };

      office = {
        enable = lib.mkEnableOption "Office suite";
        libreoffice.enable = lib.mkEnableOption "Libreoffice";
        pdf.enable = lib.mkEnableOption "pdf suite";
      };

      browsers = {
        enable = lib.mkEnableOption "Enables preferred browser module";
        firefox.enable = lib.mkEnableOption "Firefox";
      };
    };


    shells = {
      enable = lib.mkEnableOption "Enable all shells and shell configuration"; 
      fish = {
        enable = lib.mkEnableOption "Enables fish configuration";
        atuin = lib.mkEnableOption "atuin configuration";
      };
      bash = {
        enable = lib.mkEnableOption "Enables bash configuration";
        atuin = lib.mkEnableOption "atuin configuration";
      };
      aliases.enable = lib.mkEnableOption "Enables aliases";
      atuin.enable = lib.mkEnableOption "Enables atuin configuration and integration"; 
      tmux.enable = lib.mkEnableOption "Enables tmux configuration and integration"; 
    };

    dotfiles = {
      enable = lib.mkEnableOption "link dotfiles";
      # qtile.installDependencies = lib.mkEnableOption "Install Qtile dotfiles dependencies";
    };
  };

  # Defines default options for homeManagerModules
  config.homeManagerModules = {
    tooling = lib.mkIf config.homeManagerModules.tooling.enable {
      systemMonitors.enable = lib.mkDefault true;
    };

    theming = lib.mkIf config.homeManagerModules.theming.enable {
      stylix.enable = lib.mkDefault true;
    };

    gaming = lib.mkIf config.homeManagerModules.gaming.enable {
      mangohud.enable = lib.mkDefault true;
    };

    scripts = {
      # enable = lib.mk
    };

    nixvim = lib.mkIf config.homeManagerModules.nixvim.enable {
      optimizations = lib.mkDefault true;
    };

    desktop = {
      email = lib.mkIf config.homeManagerModules.desktop.email.enable {
        thunderbird.enable = lib.mkDefault true;
      };

      windowManagers = lib.mkIf config.homeManagerModules.desktop.windowManagers.enable {
        hyprland = {
          enable = lib.mkDefault true;
          hyprpaper.enable = lib.mkDefault true;
          wofi.enable = lib.mkDefault true;
          waybar.enable = lib.mkDefault true;
          swaync.enable = lib.mkDefault true;
          hyprlock.enable = lib.mkDefault true;
          cliphist.enable = lib.mkDefault true;
          hypridle.enable = lib.mkDefault true;
        };
      };

      office = lib.mkIf config.homeManagerModules.desktop.office.enable {
        libreoffice.enable = lib.mkDefault true;
        pdf.enable = lib.mkDefault true;
      };

      browsers = lib.mkIf config.homeManagerModules.desktop.browsers.enable {
        firefox.enable = lib.mkDefault true;
      };

      terminals = lib.mkIf config.homeManagerModules.desktop.terminals.enable {
        wezterm.enable = lib.mkDefault true;
      };
    };

    shells = lib.mkIf config.homeManagerModules.shells.enable {
      fish = {
        enable = lib.mkDefault true;
        atuin = lib.mkDefault true;
      };
      bash = {
        enable = lib.mkDefault true;
        atuin = lib.mkDefault true;
      };
      aliases.enable = lib.mkDefault true;
      atuin.enable = lib.mkDefault true; 
      tmux.enable = lib.mkDefault true;
    };

    dotfiles = {
      # enable = lib.mkDefault true;
    };
  };
}
