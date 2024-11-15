{ config, lib, ... }:
{
  imports = [
    ./kanata
    ./gaming
  ];

  options.nixosModules = {
    kanata = {
      enable = lib.mkEnableOption "Enables full kanata keyboard configuration";
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
    gaming = {
      # optimizations = lib.mkDefault config.nixosModules.gaming.optimizations.enable {
      # };
      games = lib.mkIf config.nixosModules.gaming.games.enable {
        prismlauncher.enable = lib.mkDefault true;
      };
    };
  };
}
