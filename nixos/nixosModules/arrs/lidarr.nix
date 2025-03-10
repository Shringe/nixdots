{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.lidarr;
in {
  options.nixosModules.arrs.lidarr = {
    enable = mkEnableOption "Lidarr music management";
    port = mkOption {
      type = types.port;
      default = 43020;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    services.lidarr = {
      enable = true;
      user = "jsparrow";
      settings = {
        server.port = cfg.port;
      };
    };
  };
}
