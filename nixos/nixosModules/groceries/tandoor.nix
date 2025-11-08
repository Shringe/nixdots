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
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
    };

    description = mkOption {
      type = types.str;
      default = "Recipe Sharing and Grocery List.";
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.ip}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://tandoor.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.str;
      default = "tandoor-recipes.svg";
    };
  };

  config = mkIf cfg.enable {
    services = {
      tandoor-recipes = {
        enable = true;
        address = cfg.ip;
        port = cfg.port;
      };
    };

    systemd.services.tandoor-recipes = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
