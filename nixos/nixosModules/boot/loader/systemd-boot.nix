{
  config,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.boot.loader.systemd-boot;
  secureboot = config.nixosModules.boot.secureboot;
in
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  options.nixosModules.boot.loader.systemd-boot = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.boot.loader.enable;
    };
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };

      loader.systemd-boot.enable = mkForce (!secureboot);
      lanzaboote = mkIf secureboot {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
  };
}
