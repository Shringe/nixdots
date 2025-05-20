{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.groceries.tandoor;
in {
  options.nixosModules.groceries.tandoor = {
    enable = mkEnableOption "Tandoor grocery list and manager";
    port = mkOption {
      type = types.port;
      default = 47380;
    };

    ip = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };

    description = mkOption {
      type = types.string;
      default = "Recipe Sharing and Grocery List.";
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.ip}:${toString cfg.port}";
    };

    icon = mkOption {
      type = types.string;
      default = "tandoor-recipes.svg";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    services = {
      tandoor-recipes = {
        enable = true;
        address = cfg.ip;
        port = cfg.port;
      };
    };
  };
}
