{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.reverseProxy.acme;
in {
  options.nixosModules.reverseProxy.acme = {
    enable = mkEnableOption "ACME certs";

    domain = mkOption {
      type = types.string;
      default = config.nixosModules.reverseProxy.domain;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "ssl/porkbun" = {};
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "dashingkoso@gmail.com";

      certs."${cfg.domain}" = {
        domain = cfg.domain;
        extraDomainNames = [ "*.${cfg.domain}" ];
        dnsProvider = "porkbun";
        credentialsFile = config.sops.secrets."ssl/porkbun".path;
      };
    };
  };
}
