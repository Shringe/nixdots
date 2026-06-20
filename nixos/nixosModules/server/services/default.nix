{ config, lib, ... }:
with lib;
{
  imports = [
    ./searxng
    ./homeAssistant
    ./minecraft
    ./paperless.nix
    ./nextcloud.nix
    ./collabora.nix
    ./immich.nix
    ./traccar.nix
    ./whalecrab.nix
    ./tmodloader.nix
    ./mumble.nix
    ./ollama.nix
    ./ark.nix
    ./samba.nix
  ];

  options.nixosModules.server.services = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.enable;
    };
  };
}
