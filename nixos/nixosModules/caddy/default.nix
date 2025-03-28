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
      virtualHosts = with config.nixosModules; {
        "files.deamicis.top" = {
          useACMEHost = "deamicis.top";
          extraConfig = ''
            reverse_proxy ${filebrowser.url}
          '';
        };

        "ssh.deamicis.top" = {
          useACMEHost = "deamicis.top";
          extraConfig = ''
            reverse_proxy = ${info.system.ips.local}:${toString ssh.server.port}
          '';
        };

        # "jellyfin.deamicis.top" = {
        #   useACMEHost = "deamicis.top";
        #   extraConfig = ''
        #     reverse_proxy ${jellyfin.server.url}
        #   '';
        # };
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
