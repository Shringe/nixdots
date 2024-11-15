{ config, lib, ... }:
{
  imports = [
    ./kanata
  ];

  options.nixosModules = {
    kanata = {
      enable = lib.mkEnableOption "Enables full kanata keyboard configuration";
    };
  };
  # config.nixosModules = {
  # };
}
