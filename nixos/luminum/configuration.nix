# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./crazyUsb.nix
  ];

  nixosModules = {
    theming.enable = true;
    jellyfin.enable = true;
    networking.wireless.enable = true;
    boot = {
      secureboot = true;
      graphical.plymouth.enable = true;
    };

    desktop = {
      enable = true;
      syncthing = {
        enable = true;
        user = "shringe";
      };
    };

    hardware = {
      kanata.enable = true;
      bluetooth.enable = true;
      battery.enable = true;
    };

    gaming = {
      optimizations.enable = true;
      steam.enable = true;
      games.enable = true;
      emulators.enable = true;
    };

    users.shringe.enable = true;
  };

  sops.secrets."wireguard/clients/luminum" = { };
  networking.wg-quick.interfaces.wg0.configFile =
    config.sops.secrets."wireguard/clients/luminum".path;

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
