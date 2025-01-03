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
  ];

  options.nixosModules = {
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
