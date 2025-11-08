{ config, lib, ... }:
with lib;
{
  options.nixosModules.server.router = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.enable;
    };

    description = mkOption {
      type = types.str;
      default = "Networking Admin Panel";
    };

    url = mkOption {
      type = types.str;
      default = "http://192.168.0.1";
    };

    furl = mkOption {
      type = types.str;
      default = "https://router.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.str;
      default = "router.svg";
    };
  };
}

