{ config, lib, ... }:
let
  cfg = config.nixosModules.networking.firewall.kdeconnect;
in
{
  networking.firewall = lib.mkIf cfg.enable {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  };
}
