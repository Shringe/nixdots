{ config, lib, ... }:
# WIP
with lib;
let
  cfg = config.nixosModules.blocky;
in {
  options.nixosModules.blocky = {
    enable = mkEnableOption "Blocky adblocker";
    ports = {
      dns = mkOption {
        type = types.int;
        default = 53;
      };
      http = mkOption {
        type = types.int;
        default = 4000;
      };
      tls = mkOption {
        type = types.int;
        default = 853;
      };
    };
  };

  config = mkIf cfg.enable {
    services.blocky = {
      enable = true;
      settings = {
        # log.level = "error";
        log.level = "info";

        ports = {
          dns = cfg.ports.dns;
          http = cfg.ports.http;
          tls = cfg.ports.tls;
        };

        upstreams.groups.default = [
          "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
        ];

        # For initially solving DoH/DoT Requests when no system Resolver is available.
        bootstrapDns = {
          upstream = "https://one.one.one.one/dns-query";
          ips = [ "1.1.1.1" "1.0.0.1" ];
        };

        #Enable Blocking of certain domains.
        blocking = {
          denylists = {
            ads = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];
            testblocker = [ ./testblocker ];
          };

          clientGroupsBlock = {
            default = [ "testblocker" ];
          };
        };
      };
    };
  };
}
