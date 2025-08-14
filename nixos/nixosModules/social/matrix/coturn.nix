{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.social.matrix.coturn;

  domain = config.nixosModules.reverseProxy.aDomain;
in
{
  options.nixosModules.social.matrix.coturn = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.social.matrix.conduit.enable;
    };

    host = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "social/matrix/coturn" = {
        owner = "turnserver";
      };
      "ssl/porkbun" = { };
    };

    services.coturn = rec {
      enable = true;

      no-cli = true;
      no-tcp-relay = true;

      min-port = 49000;
      max-port = 49100;

      use-auth-secret = true;
      static-auth-secret-file = config.sops.secrets."social/matrix/coturn".path;

      realm = "turn.${domain}";

      cert = "${config.security.acme.certs.${realm}.directory}/full.pem";
      pkey = "${config.security.acme.certs.${realm}.directory}/key.pem";
    };

    # open the firewall
    networking.firewall =
      let
        range =
          with config.services.coturn;
          singleton {
            from = min-port;
            to = max-port;
          };
      in
      {
        allowedUDPPortRanges = range;
        allowedUDPPorts = [
          3478
          5349
        ];
        allowedTCPPortRanges = [ ];
        allowedTCPPorts = [
          3478
          5349
        ];
      };

    security.acme.certs."turn.${domain}" = {
      group = "turnserver";
      dnsProvider = "porkbun";
      credentialsFile = config.sops.secrets."ssl/porkbun".path;
    };
  };
}
