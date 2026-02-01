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
    ./disko.nix
  ];

  hardware.enableAllFirmware = true;

  # Basic static ip for faster boot
  networking = {
    dhcpcd.enable = true;
    interfaces.enp42s0 = {
      ipv4.addresses = [
        {
          address = config.nixosModules.info.system.ips.local;
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = "192.168.0.1";
    nameservers = [ config.nixosModules.info.system.ips.local ];
  };

  # Useful for filtering out failed builds from source
  # nix.settings.max-jobs = 1;

  nixosModules = {
    info.system = {
      ips.local = "192.168.0.165";
    };

    reporting.enable = true;
    theming = {
      enable = true;
      wallpapers = {
        primary = ./../../assets/wallpapers/PurpleFluid_3440x1440.png;
        secondary = ./../../assets/wallpapers/BlossomsCatppuccin_3440x1440.png;
      };
    };

    drives = {
      backups1.enable = false;
      smedia1.enable = true;
      smedia2.enable = true;
      steamssd1.enable = true;
      steamssd2.enable = false;
    };

    # btrfs send/receive seems to be creating more errors on bad disk
    backups.btrbk.enable = true;

    players.mpv.enable = true;

    server.enable = true;

    # TODO: wait for binary cache
    server.services.paperless.enable = false;

    kavita.enable = true;
    groceries.tandoor.enable = true;

    social = {
      matrix.conduit.enable = true;
    };

    reverseProxy = {
      enable = true;
    };

    monitors = {
      gatus.enable = true;
    };

    shell = {
      atuin.server.enable = true;
    };

    torrent.qbittorrent.enable = true;

    arrs = {
      lidarr.enable = false;
      sonarr.enable = true;
      prowlarr.enable = true;
      # radarr.enable = true;
      flaresolverr.enable = true;
      vpn.enable = true;
    };

    linkwarden.enable = true;

    docker = {
      enable = true;
      romm.enable = true;
      wallos.enable = true;
    };

    homepage.enable = true;

    wireguard = {
      enable = true;
      server.enable = true;
    };

    jellyfin = {
      enable = true;
      # jellyseerr.enable = true;
      server.enable = true;
    };

    vpn = {
      enable = true;
      airvpn.enable = true;
    };

    firewall = {
      enable = true;
      kdeconnect.enable = true;
      yuzu.enable = true;
    };

    desktop = {
      enable = true;
      adb.enable = true;
      syncthing = {
        enable = true;
        user = "shringed";
      };
    };

    gaming = {
      # alvr.enable = true;
      servers = {
        # ase.Gatsby.enable = true;
      };

      optimizations.enable = true;
      optimizations.conservePower = false;
      tooling.enable = true;
      steam.enable = true;
      games.enable = true;
      emulators.enable = true;
    };

    hardware = {
      openrgb.enable = true;
      printers.enable = true;
      kanata.enable = true;
      nvidia.enable = true;
      bluetooth.enable = true;
      audio.enable = true;
    };

    users = {
      shringed.enable = true;
    };

    mouse.main.enable = true;
  };

  boot.loader.systemd-boot.memtest86.enable = true;

  # Zenpower driver
  boot.extraModulePackages = with config.boot.kernelPackages; [
    zenpower
    nct6687d
  ];

  boot.kernelModules = [
    "zenpower"
    "nct6687"
  ];

  boot.blacklistedKernelModules = [ "k10temp" ];

  programs.gpu-screen-recorder.enable = true;

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
      btop
      htop

      nix-search-cli
      nh

      btrfs-progs
      compsize
      cryptsetup

      gpu-screen-recorder-gtk
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  programs.coolercontrol.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?
}
