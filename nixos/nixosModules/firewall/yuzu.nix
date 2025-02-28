{ config, lib, ... }:
let 
  cfg = config.nixosModules.firewall.yuzu;
in
{
  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        24872
      ];
      allowedUDPPorts = [
        24872
      ];
    };
  };
}
