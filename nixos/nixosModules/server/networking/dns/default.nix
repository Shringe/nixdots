{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.server.networking.dns;
in {
  imports = [
    ./blocky.nix
    ./adguard.nix
  ];

  options.nixosModules.server.networking.dns = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.networking.enable;
    };

    ports = {
      webui = mkOption {
        type = types.port;
        default = 47120;
      };

      dns = mkOption {
        type = types.port;
        default = 47100;
      };
    };

    dns = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };

    host = mkOption {
      type = types.string;
      default = cfg.dns;
    };

    description = mkOption {
      type = types.string;
      default = "Network-Wide Ad Blocker";
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.dns}:${toString cfg.ports.webui}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://dns.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
    };
  };
}
