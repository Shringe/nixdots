{ lib, ... }:
with lib;
{
  imports = [
    ./superuser
  ];

  options.nixosModules.security = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };
}
