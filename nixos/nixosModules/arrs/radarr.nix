{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.radarr;
in {
  options.nixosModules.arrs.radarr = {
    enable = mkEnableOption "Sonarr TV Show Management";
    port = mkOption {
      type = types.port;
      default = 43100;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

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
