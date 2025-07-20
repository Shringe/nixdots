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
      webInterface = false;

      drivers = [ pkgs.brlaser ];
    };

    # Scanning
    hardware.sane = {
      enable = true;

      brscan4 = {
        enable = true;

        # netDevices.brother = {
        #   model = "Brother-HL-2280DW";
        #   ip = "192.168.0.219";
        # };
      };
    };
  };
}
