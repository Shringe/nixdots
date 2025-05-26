{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.sonarr;
in {
  options.nixosModules.arrs.sonarr = {
    enable = mkEnableOption "Sonarr TV Show Management";

    ip = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 43040;
    };

    description = mkOption {
      type = types.string;
      default = "TV Show Management";
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.ip}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://sonarr.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "sonarr.svg";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."user_passwords/sonarr".neededForUsers = true;
    users.users.sonarr = {
      isSystemUser = true;
      group = "sonarr";
      hashedPasswordFile = config.sops.secrets."user_passwords/sonarr".path;
      extraGroups = [ "qbittorrent" ];
    };

    users.groups.sonarr = { };

    services.sonarr = {
      enable = true;
      user = "sonarr";
      group = "sonarr";
      settings = {
        server.port = cfg.port;
      };
    };
  };
}
