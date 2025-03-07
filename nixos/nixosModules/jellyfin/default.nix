{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.jellyfin;
in {
  imports = [
    ./client.nix
    ./server.nix
    ./jellyseerr.nix
  ];

  options.nixosModules.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin";
  };

  config = mkIf cfg.enable {
    nixosModules.jellyfin.client.enable = mkDefault true;
  };
}
