{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.server.services.nextcloud;

  domain = config.nixosModules.reverseProxy.aDomain;
in {
  options.nixosModules.server.services.nextcloud = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
    };

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
      default = "nextcloud.${domain}";
    };

    directory = mkOption {
      type = types.str;
      default = "/mnt/server/critical/nextcloud";
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

      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
      };

      config = {
        adminuser = "nextcloud";
        adminpassFile = config.sops.secrets."nextcloud/passwords/admin".path;
        dbtype = "pgsql";
      };
    };

    services.nginx.virtualHosts.${cfg.hostName} = {
      onlySSL = true;
      useACMEHost = domain;
    };

    systemd.services.nextcloud-setup.serviceConfig = {
      RequiresMountsFor = [ cfg.directory ];
    };
  };
}
