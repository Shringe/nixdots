{ config, lib, ... }:
let 
  cfg = config.nixosModules.firewall.kdeconnect;
in
{
  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; }
      ];
      allowedUDPPortRanges = [
        { from = 1714; to = 1764; }
      ];
    };
  };
}
