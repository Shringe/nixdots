{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.caddy;
in {
  options.nixosModules.caddy = {
    enable = mkEnableOption "Caddy";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    sops.secrets = {
      "ssl/porkbun" = {};
    };

    services.caddy = {
      enable = true;
      virtualHosts = {
        "files.deamicis.top" = {
          useACMEHost = "deamicis.top";
          extraConfig = ''
            reverse_proxy http://66.208.98.226:47060
          '';
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "dashingkoso@gmail.com";

      certs."deamicis.top" = {
        domain = "deamicis.top";
        extraDomainNames = [ "*.deamicis.top" ];
        dnsProvider = "porkbun";
        credentialsFile = config.sops.secrets."ssl/porkbun".path;
      };
    };

    users.users.caddy.extraGroups = [ "acme" ];
  };
}
