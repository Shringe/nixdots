{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.hardware.printers.brotherhl2280dw;
in {
  options.nixosModules.hardware.printers.brotherhl2280dw = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.hardware.printers.enable;
    };
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
    };
  };
}
