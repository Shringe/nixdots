{ config,  lib, ... }:
with lib;
{
  imports = [
    ./kanata
    ./gaming
    ./wireless
    ./battery
    ./desktop
    ./sops
    ./users
    ./mouse
    ./drivers
    ./llm
    ./packages
    ./bluetooth
    ./firewall
    ./vpn
    ./jellyfin
    # ./seafile
    ./docker

    # These define their own options and config
    ./wireguard
    ./uptimeKuma
    ./arrs
    ./torrent
    ./guacamole
    ./ombi
    ./shell
    ./info
    ./homepage
    ./filebrowser
    ./caldav
    ./monitors
    ./players
    # ./caddy
    ./nextcloud
    ./reverseProxy
    ./drives
    ./album
    ./maintenance
    ./social
    ./backups
    ./kavita
    ./groceries
    ./authelia
    ./linkwarden
    ./gps
    ./security
    ./server
    ./theming
    ./boot
    ./hardware
  ];

  options.nixosModules = {
    docker = {
      enable = mkEnableOption "Docker configuration";
      automaticrippingmachine = {
        enable = mkEnableOption "automaticrippingmachine";
        port = mkOption {
          type = types.port;
          default = 8080;
        };
      };
    };

    vpn = {
      enable = mkEnableOption "Preferred vpn";
      nordvpn.enable = mkEnableOption "nordvpn";
    };

    firewall = {
      enable = mkEnableOption "Enables firewall";
      kdeconnect.enable = mkEnableOption "Enables kdeconnect firewall ports";
      yuzu.enable = mkEnableOption "Enables yuzu LAN firewall ports";
    };

    bluetooth = {
      enable = mkEnableOption "Bluetooth configuration";
    };

    llm = {
      gpt4all = {
        enable = mkEnableOption "Default gpt4all";
        cuda = mkEnableOption "Use Cuda";
      };
    };

    drivers = {
      nvidia.enable = mkEnableOption "Nvidia drivers";
    };

    mouse = {
      main.enable = mkEnableOption "Proper mouse settings.";
    };

    users = {
      shringe.enable = mkEnableOption "Laptop user";
      shringed.enable = mkEnableOption "Desktop user";
    };

    desktop = {
      windowManagers = {
        qtile.enable = mkEnableOption "Qtile dependencies";
        hyprland.enable = mkEnableOption "hyprland setup";
      };
    };

    kanata = {
      enable = mkEnableOption "Enables full kanata keyboard configuration";
      variant = mkOption {
        type = types.str;
        default = "main";
        description = "What .kbd file to use. Options can be found in ./kanata/";
      };
    };

    wireless = {
      enable = mkEnableOption "Enables wireless connections";
      fixes = {
        unblockWlan.enable = mkEnableOption "Automatically unblocks wlan on startup";
      };
    };

    battery = {
      enable = mkEnableOption "Enables default battey conscience power management";
      tooling.enable = mkEnableOption "Enables tooling.";
      powerManagement.enable = mkEnableOption "Enables power conservation";
    };

    gaming = {
      tooling.enable = mkEnableOption "Extra tooling";

      emulators = {
        switch = {
          enable = mkEnableOption "Switch emulator";
          torzu.enable = mkEnableOption "A switch emulator";
        };
      };

      optimizations = {
        enable = mkEnableOption "Full optimizations";
      };
      steam = {
        enable = mkEnableOption "Steam configuration";
      };
      games = {
        enable = mkEnableOption "All other games";
        prismlauncher.enable = mkEnableOption "prismlauncer configuration";
      };
    };
  };

  config.nixosModules = {
    jellyfin = mkIf config.nixosModules.jellyfin.enable {
      client.enable = mkDefault true;
    };

    vpn = mkIf config.nixosModules.vpn.enable {
      nordvpn.enabled = mkDefault true;
    };

    battery = mkIf config.nixosModules.battery.enable {
      tooling.enable = mkDefault true;
      powerManagement.enable = mkDefault true;
    };

    gaming = {
      emulators = {
        switch = mkIf config.nixosModules.gaming.emulators.switch.enable {
          torzu.enable = mkDefault true;
        };
      };

      # optimizations = mkDefault config.nixosModules.gaming.optimizations.enable {
      # };
      games = mkIf config.nixosModules.gaming.games.enable {
        prismlauncher.enable = mkDefault true;
      };
    };
  };
}
