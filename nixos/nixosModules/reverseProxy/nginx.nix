{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.reverseProxy.nginx;

  d = cfg.domain;
  ad = cfg.aDomain;

  reverseProxy = url: domain: {
    useACMEHost = domain;
    onlySSL = true;

    locations."/" = {
      proxyPass = url;
    };
  };

  rp = url: (reverseProxy url d);
  rpa = url: (reverseProxy url ad);
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

      virtualHosts = with config.nixosModules; {
        # IMPORTANT
        # Reject Unmatched Domains
        "_" = {
          default = true;
          rejectSSL = true;
          extraConfig = ''
            return 444;
          '';
        };

        # Private
        "jellyfin.${d}" = (rp jellyfin.server.url);
        "dash.${d}" = (rp homepage.url);
        "tandoor.${d}" = (rp groceries.tandoor.url);
        "kavita.${d}" = (rp kavita.url);
        "gatus.${d}" = (rp monitors.gatus.url);
        "jellyseerr.${d}" = (rp jellyfin.jellyseerr.url);
        "adguard.${d}" = (rp adblock.adguard.url);
        "immich.${d}" = (rp album.immich.url);
        "radicale.${d}" = (rp caldav.radicale.url);
        "ollama.${d}" = (rp llm.ollama.webui.url);
        "router.${d}" = (rp "http://192.168.0.1");
        "lidarr.${d}" = (rp arrs.lidarr.url);
        "radarr.${d}" = (rp arrs.radarr.url);
        "sonarr.${d}" = (rp arrs.sonarr.url);
        "prowlarr.${d}" = (rp arrs.prowlarr.url);
        "torrent.${d}" = (rp torrent.qbittorrent.url);
        "flaresolverr.${d}" = (rp arrs.flaresolverr.url);
        "atuin.${d}" = (rp shell.atuin.server.url);
        "romm.${d}" = (rp docker.romm.url);
        "linkwarden.${d}" = (rp linkwarden.url);
        "ourshoppinglist.${d}" = (rp docker.ourshoppinglist.url);
        "traccar.${d}" = (rp gps.traccar.url);
        "wallos.${d}" = (rp docker.wallos.url);
        "files.${d}" = (rp filebrowser.url);
      
        # Public
        "ssh.${d}" = (rp "http://${info.system.ips.local}:${toString ssh.server.port}");
        ad = (rpa social.matrix.conduit.url);
      };
    };

    users.users.nginx.extraGroups = [ "acme" ];
  };
}
