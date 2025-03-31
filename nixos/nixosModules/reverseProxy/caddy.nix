
{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.reverseProxy.caddy;
in {
  options.nixosModules.reverseProxy.caddy = {
    enable = mkEnableOption "Caddy";

    domain = mkOption {
      type = types.string;
      default = config.nixosModules.reverseProxy.domain;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    sops.secrets = {
      "ssl/porkbun" = {};
    };

    services.caddy = {
      enable = true;
      virtualHosts = with config.nixosModules; {
        "files.${cfg.domain}" = {
          useACMEHost = cfg.domain;
          extraConfig = ''
            reverse_proxy ${filebrowser.url}
          '';
        };

        "ssh.${cfg.domain}" = {
          useACMEHost = cfg.domain;
          extraConfig = ''
            reverse_proxy = ${info.system.ips.local}:${toString ssh.server.port}
          '';
        };

        "cloud.${cfg.domain}" = {
          useACMEHost = cfg.domain;
          extraConfig = ''
            reverse_proxy = http://127.0.0.1:8082
          '';
        };

        # "jellyfin.${cfg.domain}" = {
        #   useACMEHost = "${cfg.domain}";
        #   extraConfig = ''
        #     reverse_proxy ${jellyfin.server.url}
        #   '';
        # };
     };
    };

    users.users.caddy.extraGroups = [ "acme" ];
  };
}
