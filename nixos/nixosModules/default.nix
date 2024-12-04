{ config, lib, ... }:
{
  imports = [
    ./kanata
    ./gaming
  ];

  options.nixosModules = {
    kanata = {
      enable = lib.mkEnableOption "Enables full kanata keyboard configuration";
      variant = lib.mkOption {
        type = lib.types.str;
        default = "main";
        description = "What .kbd file to use. Options can be found in ./kanata/";
      };
    };

    battery = {
      enable = lib.mkEnableOption "Enables default battey conscience power management";
      tooling.enable = lib.mkEnableOption "Enables tooling.";
      powerManagement.enable = lib.mkEnableOption "Enables power conservation";
    };

    gaming = {
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
