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

  nixosModules = {
    info.system  = {
      ips.local = "192.168.0.165";
    };

    gps.traccar.enable = true;

    album.immich.enable = true;
    backups.btrbk.enable = true;
    kavita.enable = true;
    groceries.tandoor.enable = true;
    authelia.enable = false;

    social = {
      jitsi.enable = true;
      matrix.conduit.enable = true;
    };

    reverseProxy = {
      enable = true;
    };

    players.mpv.enable = true;

    monitors = {
      gatus.enable = true;
    };

    caldav.enable = true;

    shell = {
      atuin.server.enable = true;
    };

    adblock.enable = true;
    # guacamole.enable = true;
    # ombi.enable = true;

    ssh = {
      server.enable = true;
    };

    torrent.qbittorrent.enable = true;

    arrs = {
      lidarr.enable = true;
      sonarr.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      flaresolverr.enable = true;
      vpn.enable = true;
    };

    # uptimeKuma = {
    #   enable = true;
    # };

    linkwarden.enable = true;

    docker = {
      enable = true;
      romm.enable = true;
      ourshoppinglist.enable = true;
      wallos.enable = true;
    };

    homepage.enable = true;

    filebrowser = {
      enable = true;
    };

    nextcloud.enable = true;

    wireguard = {
      enable = true;
      server.enable = true;
    };

    jellyfin = {
      enable = true;
      jellyseerr.enable = true;
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

    theming = {
      enable = true;
    };

    llm = {
      ollama = {
        enable = true;
        enableCuda = true;
        webui.enable = true;
      };

      gpt4all = {
        # enable = true;
        # cuda = true;
      };
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
      windowManagers = {
        sway.enable = true;
      };
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
    systemPackages = with pkgs; with config.shared.packages; [
      nordvpn
      
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

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  #: networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}

