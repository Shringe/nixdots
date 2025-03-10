{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.radarr;
in {
  options.nixosModules.arrs.radarr = {
    enable = mkEnableOption "Sonarr TV Show Management";
    port = mkOption {
      type = types.port;
      default = 43100;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    services.radarr = {
      enable = true;
      user = "jsparrow";
      settings = {
        server.port = cfg.port;
      };
    };
  };
}
