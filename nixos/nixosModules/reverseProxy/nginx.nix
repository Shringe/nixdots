{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.reverseProxy.nginx;

  mkReverseProxy = url: domain: {
    useACMEHost = domain;
    onlySSL = true;

    locations."/" = {
      proxyPass = url;
    };
  };

  reverseProxyDomain = domain: module: optionalAttrs module.enable {
    ${domain} = mkReverseProxy module.url domain;
  };

  reverseProxySubdomain = subdomain: domain: module: optionalAttrs module.enable {
    "${subdomain}.${domain}" = mkReverseProxy module.url domain;
  };

  rps = subdomain: module: reverseProxySubdomain subdomain cfg.domain module;
  rpd = module: reverseProxyDomain cfg.domain module;

  rpas = subdomain: module: reverseProxySubdomain subdomain cfg.aDomain module;
  rpad = module: reverseProxyDomain cfg.aDomain module;
in {
  options.nixosModules.reverseProxy.nginx = {
    enable = mkEnableOption "Nginx";

    domain = mkOption {
      type = types.string;
      default = config.nixosModules.reverseProxy.domain;
    };

    aDomain = mkOption {
      type = types.string;
      default = config.nixosModules.reverseProxy.aDomain;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 443 ];

    services.nginx = {
      enable = true;

      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedZstdSettings = true;

      virtualHosts = with config.nixosModules; mkMerge [
        # IMPORTANT - Reject Unmatched Domains
        {
          "_" = {
            default = true;
            rejectSSL = true;
            extraConfig = ''
              return 444;
            '';
          };
        }

        # Private services
        (rps "jellyfin" jellyfin.server)
        (rps "dash" homepage)
        (rps "tandoor" groceries.tandoor)
        (rps "kavita" kavita)
        (rps "gatus" monitors.gatus)
        (rps "jellyseerr" jellyfin.jellyseerr)
        (rps "adguard" adblock.adguard)
        (rps "immich" album.immich)
        (rps "radicale" caldav.radicale)
        (rps "ollama" llm.ollama.webui)
        (rps "lidarr" arrs.lidarr)
        (rps "radarr" arrs.radarr)
        (rps "sonarr" arrs.sonarr)
        (rps "prowlarr" arrs.prowlarr)
        (rps "torrent" torrent.qbittorrent)
        (rps "flaresolverr" arrs.flaresolverr)
        (rps "atuin" shell.atuin.server)
        (rps "romm" docker.romm)
        (rps "linkwarden" linkwarden)
        (rps "ourshoppinglist" docker.ourshoppinglist)
        (rps "traccar" gps.traccar)
        (rps "wallos" docker.wallos)
        (rps "files" filebrowser)
        (rps "router" server.router)
        (rps "ssh" server.ssh)

        # Public services
        (rpad social.matrix.conduit)
      ];
    };

    users.users.nginx.extraGroups = [ "acme" ];
  };
}
