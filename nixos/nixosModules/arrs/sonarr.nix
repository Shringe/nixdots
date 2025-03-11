{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.sonarr;
in {
  options.nixosModules.arrs.sonarr = {
    enable = mkEnableOption "Sonarr TV Show Management";
    port = mkOption {
      type = types.port;
      default = 43040;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

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
