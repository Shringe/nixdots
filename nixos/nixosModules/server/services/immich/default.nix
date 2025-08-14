{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.server.services.immich;
in
{
  options.nixosModules.server.services.immich = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
    };

    host = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 47260;
    };

    description = mkOption {
      type = types.string;
      default = "Photo Album";
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://immich.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "immich.svg";
    };

    directory = mkOption {
      type = types.string;
      default = "/mnt/server/critical/immich";
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /mnt/server/critical/immich 0700 immich immich -"
    ];

    services.immich = {
      enable = true;
      package = pkgs.stable.immich;
      host = cfg.host;
      port = cfg.port;

      redis.enable = true;
      mediaLocation = cfg.directory;
    };
  };
}
