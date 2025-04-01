{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.nextcloud;
in {
  options.nixosModules.nextcloud = {
    enable = mkEnableOption "Nextcloud hosting";

    host = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "nextcloud/passwords/admin" = {};
    };

    users.users.nextcloud.extraGroups = ["users"];
    services.nginx.virtualHosts."cloud.${config.nixosModules.reverseProxy.domain}".listen = [ { addr = cfg.host; port = 8082; } ];

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "cloud.${config.nixosModules.reverseProxy.domain}";
      database.createLocally = true;
      # configureRedis = true;

      config = {
        adminuser = "nextcloud";
        adminpassFile = config.sops.secrets."nextcloud/passwords/admin".path;
        dbtype = "mysql";
        # config_is_read_only = true;
      };

      settings = {
        trusted_proxies = [ cfg.host ];
      };
    };
  };
}
