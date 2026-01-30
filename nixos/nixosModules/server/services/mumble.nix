{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.server.services.mumble;
  domain = config.nixosModules.reverseProxy.domain;
  sslCertDir = config.security.acme.certs.${domain}.directory;
in
{
  options.nixosModules.server.services.mumble = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
    };

    host = mkOption {
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 64738;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."server/services/mumble" = { };
    users.users.murmur.extraGroups = [ "acme" ];

    services.murmur = {
      enable = true;
      openFirewall = true;
      sslCert = "${sslCertDir}/fullchain.pem";
      sslCa = "${sslCertDir}/chain.pem";
      sslKey = "${sslCertDir}/key.pem";
      registerHostname = domain;
      port = cfg.port;
      hostName = cfg.host;
      environmentFile = config.sops.secrets."server/services/mumble".path;
      password = "$MURMUR_PASSWORD";
      bandwidth = 12000000;
    };
  };
}
