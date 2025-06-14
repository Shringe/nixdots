
{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.reverseProxy.nginx;

  d = cfg.domain;
  rp = url: {
    useACMEHost = d;
    onlySSL = true;

    locations."/" = {
      proxyPass = url;
    };
  };
in {
  options.nixosModules.reverseProxy.nginx = {
    enable = mkEnableOption "Nginx";

    domain = mkOption {
      type = types.string;
      default = config.nixosModules.reverseProxy.domain;
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
        # Public
        "files.${d}" = (rp filebrowser.url);
        "ssh.${d}" = (rp "http://${info.system.ips.local}:${toString ssh.server.port}");
        "matrix.${d}" = (rp "http://${info.system.ips.local}:${toString social.matrix.conduit.port}");
        # "auth.${d}" = (rp "${info.system.ips.local}:${toString authelia.port}");

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

     };
    };

    users.users.nginx.extraGroups = [ "acme" ];
  };
}
