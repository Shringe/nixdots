{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.lidarr;
in
{
  options.nixosModules.arrs.lidarr = {
    enable = mkEnableOption "Lidarr music management";

    ip = mkOption {
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 43020;
    };

    description = mkOption {
      type = types.str;
      default = "Music Management";
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.ip}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://lidarr.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.str;
      default = "lidarr.svg";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."user_passwords/lidarr".neededForUsers = true;
    users.users.lidarr = {
      isSystemUser = true;
      group = "lidarr";
      hashedPasswordFile = config.sops.secrets."user_passwords/lidarr".path;
      extraGroups = [ "qbittorrent" ];
    };

    users.groups.lidarr = { };

    services.lidarr = {
      enable = true;
      user = "lidarr";
      group = "lidarr";

      settings = {
        server.port = cfg.port;
      };
    };
  };
}
