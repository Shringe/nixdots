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

    description = mkOption {
      type = types.string;
      default = "All-In-One Media Requests Hub";
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    icon = mkOption {
      type = types.string;
      default = "film-reel.svg";
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
