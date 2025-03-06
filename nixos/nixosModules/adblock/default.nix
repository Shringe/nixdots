{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.adblock;
in {
  imports = [
    ./blocky.nix
    ./adguard.nix
  ];

  options.nixosModules.adblock = {
    enable = mkEnableOption "Adblock dns";
  };

  config = mkIf cfg.enable {
    nixosModules.adblock.adguard.enable = mkDefault true;
  };
}
