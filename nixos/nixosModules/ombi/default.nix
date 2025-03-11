{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.ombi;
in
{
  options.nixosModules.ombi = {
    enable = mkEnableOption "Ombi Media Requests";

    port = mkOption {
      type = types.port;
      default = 47180;
    };
  };

  config = mkIf cfg.enable {
    services.ombi = {
      enable = true;
      port = cfg.port;
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
