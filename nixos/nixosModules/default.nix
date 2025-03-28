{ config, lib, ... }:
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
    ./openrgb
    ./drivers
    ./boot
    ./llm
    ./themes
    ./packages
    ./printing
    ./bluetooth
    ./firewall
    ./vpn
    ./jellyfin
    # ./seafile
    ./docker

    # These define their own options and config
    ./wireguard
    ./uptimeKuma
    ./adblock
    ./arrs
    ./torrent
    ./ssh
    ./guacamole
    ./ombi
    ./shell
    ./info
    ./homepage
    ./filebrowser
    ./caldav
    ./monitors
    ./players
    ./drives
    ./caddy
  ];

  options.nixosModules = {
    docker = {
      enable = lib.mkEnableOption "Docker configuration";
      automaticrippingmachine = {
        enable = lib.mkEnableOption "automaticrippingmachine";
        port = lib.mkOption {
          type = lib.types.port;
          default = 8080;
        };
      };
    };

    vpn = {
      enable = lib.mkEnableOption "Preferred vpn";
      nordvpn.enable = lib.mkEnableOption "nordvpn";
    };

    firewall = {
      enable = lib.mkEnableOption "Enables firewall";
      kdeconnect.enable = lib.mkEnableOption "Enables kdeconnect firewall ports";
      yuzu.enable = lib.mkEnableOption "Enables yuzu LAN firewall ports";
    };

    bluetooth = {
      enable = lib.mkEnableOption "Bluetooth configuration";
    };

    printing = {
      enable = lib.mkEnableOption "Printer configuration";
    };

    themes = {
      enable = lib.mkEnableOption "Nixos theming";
      stylix.enable = lib.mkEnableOption "Stylix theming";
    };

    llm = {
      gpt4all = {
        enable = lib.mkEnableOption "Default gpt4all";
        cuda = lib.mkEnableOption "Use Cuda";
      };
    };

    boot = {
      enable = lib.mkEnableOption "Default boot configuration";
      systemd-boot.enable = lib.mkEnableOption "systemd-boot";
    };

    openrgb = {
      enable = lib.mkEnableOption "OpenRGB";
    };

    drivers = {
      nvidia.enable = lib.mkEnableOption "Nvidia drivers";
    };

    mouse = {
      main.enable = lib.mkEnableOption "Proper mouse settings.";
    };

    users = {
      shringe.enable = lib.mkEnableOption "Laptop user";
      shringed.enable = lib.mkEnableOption "Desktop user";
    };

    desktop = {
      windowManagers = {
        qtile.enable = lib.mkEnableOption "Qtile dependencies";
        hyprland.enable = lib.mkEnableOption "hyprland setup";
      };
    };

    kanata = {
      enable = lib.mkEnableOption "Enables full kanata keyboard configuration";
      variant = lib.mkOption {
        type = lib.types.str;
        default = "main";
        description = "What .kbd file to use. Options can be found in ./kanata/";
      };
    };

    wireless = {
      enable = lib.mkEnableOption "Enables wireless connections";
      fixes = {
        unblockWlan.enable = lib.mkEnableOption "Automatically unblocks wlan on startup";
      };
    };

    battery = {
      enable = lib.mkEnableOption "Enables default battey conscience power management";
      tooling.enable = lib.mkEnableOption "Enables tooling.";
      powerManagement.enable = lib.mkEnableOption "Enables power conservation";
    };

    gaming = {
      tooling.enable = lib.mkEnableOption "Extra tooling";

      emulators = {
        switch = {
          enable = lib.mkEnableOption "Switch emulator";
          torzu.enable = lib.mkEnableOption "A switch emulator";
        };
      };

      optimizations = {
        enable = lib.mkEnableOption "Full optimizations";
      };
      steam = {
        enable = lib.mkEnableOption "Steam configuration";
      };
      games = {
        enable = lib.mkEnableOption "All other games";
        prismlauncher.enable = lib.mkEnableOption "prismlauncer configuration";
      };
    };
  };

  config.nixosModules = {
    jellyfin = lib.mkIf config.nixosModules.jellyfin.enable {
      client.enable = lib.mkDefault true;
    };

    vpn = lib.mkIf config.nixosModules.vpn.enable {
      nordvpn.enable = lib.mkDefault true;
    };

    themes = lib.mkIf config.nixosModules.themes.enable {
      stylix.enable = lib.mkDefault true;
    };

    boot = lib.mkIf config.nixosModules.boot.enable {
      systemd-boot.enable = lib.mkDefault true;
    };

    battery = lib.mkIf config.nixosModules.battery.enable {
      tooling.enable = lib.mkDefault true;
      powerManagement.enable = lib.mkDefault true;
    };

    gaming = {
      emulators = {
        switch = lib.mkIf config.nixosModules.gaming.emulators.switch.enable {
          torzu.enable = lib.mkDefault true;
        };
      };

      # optimizations = lib.mkDefault config.nixosModules.gaming.optimizations.enable {
      # };
      games = lib.mkIf config.nixosModules.gaming.games.enable {
        prismlauncher.enable = lib.mkDefault true;
      };
    };
  };
}
