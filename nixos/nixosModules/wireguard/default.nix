{ config, lib, ... }:
let
  cfg = config.nixosModules.wireguard;
in {
  imports = [
    ./server.nix
    ./client.nix
  ];

  options.nixosModules.wireguard = {
    enable = lib.mkEnableOption "wireguard";
    client.enable = lib.mkEnableOption "wireguard client";
  };
}
