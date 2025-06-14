{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.nextcloud;
in {
  options.nixosModules.nextcloud = {
    enable = mkEnableOption "Nextcloud hosting";

    port = mkOption {
      type = types.port;
      default = 47420;
    };

    description = mkOption {
      type = types.string;
      default = "Nextcloud Ecosystem";
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://${cfg.hostName}";
    };

    icon = mkOption {
      type = types.string;
      default = "nextcloud.svg";
    };

    hostName = mkOption {
      type = types.str;
      default = "nextcloud.${config.nixosModules.reverseProxy.domain}";
    };

    directory = mkOption {
      type = types.str;
      default = "/mnt/server/nextcloud";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "nextcloud/passwords/admin" = {};
    };

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;

      hostName = cfg.hostName;
      https = true;
      maxUploadSize = "32G";

      database.createLocally = true;
      configureRedis = true;
      home = cfg.directory;

      config = {
        adminuser = "nextcloud";
        adminpassFile = config.sops.secrets."nextcloud/passwords/admin".path;
        dbtype = "pgsql";
      };
    };

    services.nginx.virtualHosts.${cfg.hostName} = {
      onlySSL = true;
      useACMEHost = config.nixosModules.reverseProxy.domain;
    };
  };
}
