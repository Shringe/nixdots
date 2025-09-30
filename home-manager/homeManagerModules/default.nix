{ config, lib, ... }:
with lib;
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
      enable = mkEnableOption "Enable all";
      systemMonitors.enable = mkEnableOption "systemMonitors";
    };

    gaming = {
      enable = mkEnableOption "All gaming settings";
      mangohud.enable = mkEnableOption "Mangohud configuration";
    };

    sops = {
      enable = mkEnableOption "Generate sops keys";
    };

    scripts = {
      enable = mkEnableOption "packages shell scriptss";
    };

    nixvim = {
      enable = mkEnableOption "Nixvim configuration";
      optimizations = mkEnableOption "Applies expiremental performance optimizations";
    };

    desktop = {
      kdeconnect = {
        enable = mkEnableOption "Kdeconnect";
      };
      discord = {
        enable = mkEnableOption "Discord configuration";
      };

      music = {
        enable = mkEnableOption "Music players";
        termusic.enable = mkEnableOption "Termusic";
      };

      windowManagers = {
        enable = mkEnableOption "Preferred window manager";
        qtile.enable = mkEnableOption "qtile";
      };

      terminals = {
        enable = mkEnableOption "Default terminal";
        ghostty.enable = mkEnableOption "Ghostty config";
        wezterm.enable = mkEnableOption "Wezterm configuration";
        alacritty.enable = mkEnableOption "Alacritty configuration";
      };

      office = {
        enable = mkEnableOption "Office suite";
        libreoffice.enable = mkEnableOption "Libreoffice";
        pdf.enable = mkEnableOption "pdf suite";
      };

      browsers = {
        enable = mkEnableOption "Enables preferred browser module";
        chromium.enable = mkEnableOption "chromium";
      };
    };

    shells = {
      enable = mkEnableOption "Enable all shells and shell configuration";
      default = mkOption {
        type = types.str;
        default = "nu";
        description = "Default interactive shell";
      };

      fish = {
        enable = mkEnableOption "Enables fish configuration";
        atuin = mkEnableOption "atuin configuration";
      };
      bash = {
        enable = mkEnableOption "Enables bash configuration";
        atuin = mkEnableOption "atuin configuration";
      };
      aliases.enable = mkEnableOption "Enables aliases";
      atuin.enable = mkEnableOption "Enables atuin configuration and integration";
      tmux.enable = mkEnableOption "Enables tmux configuration and integration";
    };

    dotfiles = {
      enable = mkEnableOption "link dotfiles";
      # qtile.installDependencies = mkEnableOption "Install Qtile dotfiles dependencies";
    };
  };

  # Defines default options for homeManagerModules
  config.homeManagerModules = {
    tooling = mkIf config.homeManagerModules.tooling.enable {
      systemMonitors.enable = mkDefault true;
    };

    gaming = mkIf config.homeManagerModules.gaming.enable {
      mangohud.enable = mkDefault true;
    };

    scripts = {
      # enable = mk
    };

    nixvim = mkIf config.homeManagerModules.nixvim.enable {
      optimizations = mkDefault true;
    };

    desktop = {
      discord = {

      };

      music = mkIf config.homeManagerModules.desktop.music.enable {
        termusic.enable = mkDefault true;
        supersonic.enable = mkDefault true;
      };

      windowManagers = mkIf config.homeManagerModules.desktop.windowManagers.enable {
        # sway.enable = mkDefault true;
      };

      office = mkIf config.homeManagerModules.desktop.office.enable {
        libreoffice.enable = mkDefault true;
        pdf.enable = mkDefault true;
        gimp.enable = mkDefault true;
      };

      browsers = mkIf config.homeManagerModules.desktop.browsers.enable {
      };

      terminals = mkIf config.homeManagerModules.desktop.terminals.enable {
        wezterm.enable = mkDefault true;
      };
    };

    shells = mkIf config.homeManagerModules.shells.enable {
      fish = {
        enable = mkDefault true;
        atuin = mkDefault true;
      };
      bash = {
        enable = mkDefault true;
        atuin = mkDefault true;
      };
      aliases.enable = mkDefault true;
      atuin.enable = mkDefault true;
      tmux.enable = mkDefault true;
    };

    dotfiles = {
      # enable = mkDefault true;
    };
  };
}
