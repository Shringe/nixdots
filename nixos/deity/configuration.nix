# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./disko.nix
    ];
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    system-features = [ "gccarch-zen3" ];
  };

  hardware.enableAllFirmware = true;

  systemd.targets.network-online.wantedBy = lib.mkForce [];

  nixosModules = {
    info.system  = {
      ips.local = "192.168.0.165";
    };

    drives = {
      backups1.enable = true;
    };

    players.mpv.enable = true;

    server.enable = true;

    gps.traccar.enable = true;

    album.immich.enable = true;
    # backups.btrbk.enable = true;
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

    adblock.enable = true;

    # torrent.qbittorrent.enable = true;

    # arrs = {
    #   lidarr.enable = true;
    #   sonarr.enable = true;
    #   prowlarr.enable = true;
    #   radarr.enable = true;
    #   flaresolverr.enable = true;
    #   vpn.enable = true;
    # };

    linkwarden.enable = true;

    # docker = {
    #   enable = true;
    #   romm.enable = true;
    #   wallos.enable = true;
    # };

    homepage.enable = true;

    nextcloud.enable = true;

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
      yuzu.enable = false;
    };

    llm = {
      ollama = {
        enable = true;
        enableCuda = true;
        webui.enable = true;
      };
    };

    theming = {
      enable = true;
    };

    boot = {
      enable = true;
      displayManagers = {
        lightdm.enable = false;
        ly.enable = false;
        # Fails to load swayfx
        greetd.enable = false;
      };

      loaders = {
        grub.enable = false;
        systemd-boot.enable = true;
      };
    };

    desktop = {
      enable = true;
    };

    kanata = {
      enable = true;
      variant = "wide";
    };

    gaming = {
      servers = {
        # ase.Gatsby.enable = true;
      };

      emulators = {
        # switch.enable = true;
      };

      optimizations.enable = true;
      tooling.enable = true;
      steam.enable = true;
      games.enable = true;
    };

    openrgb.enable = true;

    drivers.nvidia.enable = true;

    users = {
      shringed.enable = true;
    };

    mouse.main.enable = true;
  };

  boot = {
    loader.systemd-boot.memtest86.enable = true;
    extraModulePackages = with config.boot.kernelPackages; [
      zenpower
    ];
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      icu
    ];
  };

  programs.adb.enable = true;

  hardware.bluetooth = {
    enable = true;
  };

  services.blueman.enable = true;


  # Set your time zone.
  time.timeZone = "US/Central";
  networking.hostName = "deity";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  services.xserver.displayManager.lightdm.enable = false;

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
      NH_FLAKE="/nixdots";
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

