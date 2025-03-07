{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.sonarr;
in {
  options.nixosModules.arrs.sonarr = {
    enable = mkEnableOption "Sonarr TV Show Management";
    port = mkOption {
      type = types.port;
      default = 43040;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    services.sonarr = {
      enable = true;
      settings = {
        server.port = cfg.port;
      };
    };
  };
}
