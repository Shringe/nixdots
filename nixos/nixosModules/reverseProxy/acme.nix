{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.reverseProxy.acme;
  acme = config.nixosModules.reverseProxy;
in
{
  options.nixosModules.reverseProxy.acme = {
    enable = mkEnableOption "ACME certs";
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "ssl/porkbun" = { };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "dashingkoso@gmail.com";

      certs."${acme.domain}" = {
        domain = acme.domain;
        extraDomainNames = [ "*.${acme.domain}" ];
        dnsProvider = "porkbun";
        credentialsFile = config.sops.secrets."ssl/porkbun".path;
      };

      certs."${acme.aDomain}" = {
        domain = acme.aDomain;
        extraDomainNames = [ "*.${acme.aDomain}" ];
        dnsProvider = "porkbun";
        credentialsFile = config.sops.secrets."ssl/porkbun".path;
      };

      certs."${acme.pDomain}" = {
        domain = acme.pDomain;
        extraDomainNames = [ "*.${acme.pDomain}" ];
        dnsProvider = "porkbun";
        credentialsFile = config.sops.secrets."ssl/porkbun".path;
      };
    };
  };
}
