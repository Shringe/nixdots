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
      # games = {
      # };
    };
  };
  config.nixosModules = {
    gaming = {
      # optimizations = lib.mkDefault config.nixosModules.gaming.optimizations.enable {
      #
      # };
    };
  };
}
