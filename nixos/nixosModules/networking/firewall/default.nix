{ config, lib, ... }:
let
  cfg = config.nixosModules.networking.firewall;
in
{
  imports = [
    ./kdeconnect.nix
  ];

  networking.firewall = lib.mkIf cfg.enable {
    enable = true;
  };
}
