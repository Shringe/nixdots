{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.lidarr;
in {
  options.nixosModules.arrs.lidarr = {
    enable = mkEnableOption "Lidarr music management";
    port = mkOption {
      type = types.port;
      default = 43020;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

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
