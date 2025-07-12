{ lib, ... }:
with lib;
{
  imports = [
    ./loader
    ./graphical
  ];

  options.nixosModules.boot = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };
}
