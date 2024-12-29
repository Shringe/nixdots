{ config, lib, ... }:
{
  imports = [
    ./kanata
    ./gaming
    ./networking
    ./battery
    ./desktop
    ./sops
    ./users
    ./mouse
    ./openrgb
    ./drivers
    ./development
  ];

  options.nixosModules = {
    development = {
      pi = {
        enable = lib.mkEnableOption "All Raspberry Pi dev configuration.";
        tooling.enable = lib.mkEnableOption "Extra tooling";
      };
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
      qtile.enable = lib.mkEnableOption "Qtile dependencies";
    };

    kanata = {
      enable = lib.mkEnableOption "Enables full kanata keyboard configuration";
      variant = lib.mkOption {
        type = lib.types.str;
        default = "main";
        description = "What .kbd file to use. Options can be found in ./kanata/";
      };
    };

    networking = {
      vpn = {
        nordvpn.enable = lib.mkEnableOption "Enables nordvpn";
      };

      wireless = {
        enable = lib.mkEnableOption "Enables wireless connections";
        fixes = {
          unblockWlan.enable = lib.mkEnableOption "Automatically unblocks wlan on startup";
        };
      };

      firewall = {
        enable = lib.mkEnableOption "Base firewall configration";
        kdeconnect.enable = lib.mkEnableOption "Open kdeconnect ports";
      };
    };

    battery = {
      enable = lib.mkEnableOption "Enables default battey conscience power management";
      tooling.enable = lib.mkEnableOption "Enables tooling.";
      powerManagement.enable = lib.mkEnableOption "Enables power conservation";
    };

    gaming = {
      tooling.enable = lib.mkEnableOption "Extra tooling";

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
    development = {
      pi = lib.mkIf config.nixosModules.development.pi.enable {
        tooling.enable = lib.mkDefault true;
      };
    };

    battery = lib.mkIf config.nixosModules.battery.enable {
      tooling.enable = lib.mkDefault true;
      powerManagement.enable = lib.mkDefault true;
    };

    gaming = {

      # optimizations = lib.mkDefault config.nixosModules.gaming.optimizations.enable {
      # };
      games = lib.mkIf config.nixosModules.gaming.games.enable {
        prismlauncher.enable = lib.mkDefault true;
      };
    };
  };
}
