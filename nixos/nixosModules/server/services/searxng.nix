{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.server.services.searxng;
  domain = config.nixosModules.reverseProxy.domain;
in
{
  options.nixosModules.server.services.searxng = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
    };

    port = mkOption {
      type = types.port;
      default = 47480;
    };

    description = mkOption {
      type = types.string;
      default = "Powerful MetaSearch Engine";
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://searxng.${domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "traccar.svg";
    };
  };

  config = mkIf cfg.enable {
    services.searx = {
      enable = true;
      redisCreateLocally = true;
      configureUwsgi = true;
      configureNginx = true;
      domain = domain;
    };
  };
}
