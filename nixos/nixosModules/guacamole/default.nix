{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.guacamole;
in {
  options.nixosModules.guacamole = {
    enable = mkEnableOption "Guacamole web interface";

    host = mkOption {
      type = types.string;
      default = config.nixosModules.info.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 47160;
    };
  };

  config = mkIf cfg.enable {
    services.guacamole-server = {
      enable = true;
      port = cfg.port;
      host = cfg.host;
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
