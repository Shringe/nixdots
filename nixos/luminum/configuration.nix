# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./crazyUsb.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixosModules = {
    theming.enable = true;
    vpn.enable = true;
    battery.enable = true;
    kanata.enable = true;
    desktop.enable = true;
    jellyfin.enable = true;
    networking.wireless.enable = true;
    boot = {
      secureboot = true;
      graphical.plymouth.enable = true;
    };

    gaming = {
      optimizations.enable = true;
      steam.enable = true;
      games.enable = true;
    };

    users.shringe.enable = true;
  };

  sops.secrets."wireguard/clients/luminum" = { };
  networking = {
    hostName = "luminum";
    wg-quick.interfaces.wg0.configFile = config.sops.secrets."wireguard/clients/luminum".path;
  };

  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "US/Central";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
    };
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # $ nix search wget
  environment = {
    sessionVariables = {
      NH_FLAKE = "/nixdots";
    };

    systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      git
      expect

      sops

      vim-startuptime
      fastfetch
      neovim
      picom

      fish
      eza
      bat
      #atuin
      btop
      htop

      iwgtk
      wluma

      nix-search-cli
      nh

      btrfs-progs
      compsize
      cryptsetup
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  # Don't ever change
  system.stateVersion = "24.05"; # Did you read the comment?
}
