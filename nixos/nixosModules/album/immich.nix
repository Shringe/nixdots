{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.album.immich;
in {
  options.nixosModules.album.immich = {
    enable = mkEnableOption "Immich album manager";

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
    services.immich = {
      enable = true;
      host = cfg.host;
      port = cfg.port;

      redis.enable = true;
      mediaLocation = cfg.directory;
    };
  };
}
