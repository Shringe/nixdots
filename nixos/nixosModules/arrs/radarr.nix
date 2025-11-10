{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.radarr;
in {
  options.nixosModules.arrs.radarr = {
    enable = mkEnableOption "Sonarr TV Show Management";

    ip = mkOption {
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 43100;
    };

    description = mkOption {
      type = types.str;
      default = "Movie Management";
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.ip}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://radarr.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.str;
      default = "radarr.svg";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."user_passwords/radarr".neededForUsers = true;
    users.users.radarr = {
      isSystemUser = true;
      group = "radarr";
      hashedPasswordFile = config.sops.secrets."user_passwords/radarr".path;
      extraGroups = [ "qbittorrent" ];
    };

    users.groups.radarr = { };

    services.radarr = {
      enable = true;
      user = "radarr";
      group = "radarr";
      settings = {
        server.port = cfg.port;
      };
    };
  };
}
