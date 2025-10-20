{ lib, ... }:
with lib;
{
  imports = [
    ./loader
    ./graphical
    ./zswap.nix
  ];

  options.nixosModules.boot = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };

    secureboot = mkOption {
      type = types.bool;
      default = false;
      description = "Enables secureboot on supported bootloaders (systemd-boot).";
    };
  };
}
