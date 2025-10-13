{ config, lib, ... }:
with lib;
{
  imports = [
    ./searxng
    ./paperless.nix
    ./nextcloud.nix
    ./collabora.nix
    ./immich.nix
    ./minecraft.nix
    ./traccar.nix
  ];

  options.nixosModules.server.services = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.enable;
    };
  };
}
