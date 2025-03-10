{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.prowlarr;
in {
  options.nixosModules.arrs.prowlarr = {
    enable = mkEnableOption "Prowlarr Indexer Management";
    port = mkOption {
      type = types.port;
      default = 43060;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    services.prowlarr = {
      enable = true;
      user = "jsparrow";
      settings = {
        server.port = cfg.port;
      };
    };
  };
}
