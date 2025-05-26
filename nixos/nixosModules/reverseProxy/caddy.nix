
{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.reverseProxy.caddy;

  d = cfg.domain;
  rp = url: {
    useACMEHost = d;
    extraConfig = ''
      reverse_proxy ${url}
    '';
  };
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
        # Public
        "files.${d}" = (rp filebrowser.url);
        "ssh.${d}" = (rp "${info.system.ips.local}:${toString ssh.server.port}");
        "matrix.${d}" = (rp "${info.system.ips.local}:${toString social.matrix.conduit.port}");

        # Private
        "jellyfin.${d}" = (rp jellyfin.server.url);
        "home.${d}" = (rp homepage.url);
        "tandoor.${d}" = (rp groceries.tandoor.url);
        "kavita.${d}" = (rp kavita.url);
        "gatus.${d}" = (rp monitors.gatus.url);
        "jellyseerr.${d}" = (rp jellyfin.jellyseerr.url);
        "adguard.${d}" = (rp adblock.adguard.url);
        "immich.${d}" = (rp album.immich.url);
        "radicale.${d}" = (rp caldav.radicale.url);
        "ollama.${d}" = (rp llm.ollama.webui.url);
        "router.${d}" = (rp "http://192.168.0.1");
      };
    };

    users.users.caddy.extraGroups = [ "acme" ];
  };
}
