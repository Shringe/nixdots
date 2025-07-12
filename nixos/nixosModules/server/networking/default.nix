{ config, lib, ... }:
with lib;
{
  imports = [
    ./dns
  ];

  options.nixosModules.server.networking = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.enable;
    };
  };
}
