{ config, lib, ... }:
with lib;
{
  imports = [
    ./paperless
  ];

  options.nixosModules.server.services = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.enable;
    };
  };
}
