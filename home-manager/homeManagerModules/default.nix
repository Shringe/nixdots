{ lib, config, ... }:
{
  imports = [
    ./desktop
    ./shells
    ./dotfiles
    ./nixvim
    ./scripts
    ./sops
  ];

  # Defines all options for homeManagerModules
  options.homeManagerModules = {
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
      terminals = {
        enable = lib.mkEnableOption "Default terminal";
        wezterm.enable = lib.mkEnableOption "Wezterm configuration";
        alacritty.enable = lib.mkEnableOption "Alacritty configuration";
      };
      office = {
        enable = lib.mkEnableOption "Office suite";
        libreoffice.enable = lib.mkEnableOption "Libreoffice";
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
    };

    dotfiles = {
      enable = lib.mkEnableOption "link dotfiles";
      # qtile.installDependencies = lib.mkEnableOption "Install Qtile dotfiles dependencies";
    };

    wm = {
      enable = lib.mkEnableOption "Preferred WM";
      qtile = {
        enable = lib.mkEnableOption "Qtile configuration";
        installDependencies = lib.mkEnableOption "Install Qtile configuration dependencies";
      };
    };
  };

  # Defines default options for homeManagerModules
  config.homeManagerModules = {
    scripts = {
      # enable = lib.mk
    };
    nixvim = lib.mkIf config.homeManagerModules.nixvim.enable {
      optimizations = lib.mkDefault true;
    };

    desktop = {
      office = lib.mkIf config.homeManagerModules.desktop.office.enable {
        libreoffice.enable = lib.mkDefault true;
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
    };

    dotfiles = {
      # enable = lib.mkDefault true;
    };

    wm.qtile = lib.mkIf config.homeManagerModules.wm.enable {
      enable = lib.mkDefault true;
      installDependencies = lib.mkDefault true;
    };
  };
}
