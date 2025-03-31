
{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.reverseProxy.nginx;
in {
  options.nixosModules.reverseProxy.nginx = {
    enable = mkEnableOption "Nginx";

    domain = mkOption {
      type = types.string;
      default = config.nixosModules.reverseProxy.domain;
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;

      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;

      virtualHosts = with config.nixosModules; {
        "files.${cfg.domain}" = {
          useACMEHost = cfg.domain;
          onlySSL = true;

          locations."/" = {
            proxyPass = filebrowser.url;
          };
        };

        "ssh.${cfg.domain}" = {
          useACMEHost = cfg.domain;
          onlySSL = true;

          locations."/" = {
            proxyPass = "${info.system.ips.local}:${toString ssh.server.port}";
          };
        };

        # "jellyfin.${cfg.domain}" = {
        #   useACMEHost = "${cfg.domain}";
        #   extraConfig = ''
        #     reverse_proxy ${jellyfin.server.url}
        #   '';
        # };
     };
    };

    users.users.nginx.extraGroups = [ "acme" ];
  };
}
