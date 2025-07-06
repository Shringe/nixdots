{ config, lib, ... }:
with lib;
{
  options.nixosModules.server.router = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.enable;
    };

    description = mkOption {
      type = types.string;
      default = "Networking Admin Panel";
    };

    url = mkOption {
      type = types.string;
      default = "http://192.168.0.1";
    };

    furl = mkOption {
      type = types.string;
      default = "https://router.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "router.svg";
    };
  };
}

