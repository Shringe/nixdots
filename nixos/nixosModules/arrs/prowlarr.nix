{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.prowlarr;
in {
  options.nixosModules.arrs.prowlarr = {
    enable = mkEnableOption "Prowlarr Indexer Management";
    port = mkOption {
      type = types.port;
      default = 43060;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    # users.users.prowlarr = {
    #   isSystemUser = true;
    #   group = "prowlarr";
    #   extraGroups = [ "qbittorrent" ];
    # };

    # users.groups.prowlarr = { };

    services.prowlarr = {
      enable = true;
      settings = {
        server.port = cfg.port;
      };
    };
  };
}
