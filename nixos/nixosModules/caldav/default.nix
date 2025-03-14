{ config, lib, ... }:
with lib;
let 
  cfg = config.nixosModules.caldav;
in {
  imports = [
    ./radicale.nix
  ];

  options.nixosModules.caldav = {
    enable = mkEnableOption "Enables preferred caldav server";
  };

  config = mkIf cfg.enable {
    nixosModules.caldav.radicale.enable = mkDefault true;
  };
}
