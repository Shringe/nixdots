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
    dhcpcd.enable = false;
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

  nixosModules = {
    info.system = {
      ips.local = "192.168.0.165";
    };

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
      steamssd2.enable = true;
    };

    # btrfs send/receive seems to be creating more errors on bad disk
    backups.btrbk.enable = true;

    players.mpv.enable = true;

    server.enable = true;

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
      lidarr.enable = true;
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

    llm = {
      ollama = {
        enable = true;
        enableCuda = true;
        webui.enable = true;
      };
    };

    desktop.enable = true;

    gaming = {
      alvr.enable = true;
      servers = {
        # ase.Gatsby.enable = true;
      };

      emulators = {
        switch.enable = true;
        wiiu.enable = true;
      };

      optimizations.enable = true;
      tooling.enable = true;
      steam.enable = true;
      games.enable = true;
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
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
