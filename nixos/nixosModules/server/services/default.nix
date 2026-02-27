{ config, lib, ... }:
with lib;
{
  imports = [
    ./searxng
    ./homeAssistant
    ./paperless.nix
    ./nextcloud.nix
    ./collabora.nix
    ./immich.nix
    ./minecraft.nix
    ./traccar.nix
    ./whalecrab.nix
    ./tmodloader.nix
    ./mumble.nix
    ./ollama.nix
  ];

  options.nixosModules.server.services = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.enable;
    };
  };
}
