{ config, lib, ... }:
let
  cfg = config.nixosModules.firewall;
in
{
  imports = [
    ./kdeconnect.nix
  ];

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      enable = true;
    };
  };
}
