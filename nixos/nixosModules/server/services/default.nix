{ config, lib, ... }:
with lib;
{
  imports = [
    ./paperless.nix
    ./nextcloud.nix
    ./collabora.nix
    ./immich.nix
    ./minecraft.nix
  ];

  options.nixosModules.server.services = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.enable;
    };
  };
}
