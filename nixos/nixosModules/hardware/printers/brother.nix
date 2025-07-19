{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.hardware.printers.brother;
in {
  options.nixosModules.hardware.printers.brother = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.hardware.printers.enable;
    };
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;

      drivers = [ pkgs.brlaser ];
    };
  };
}
