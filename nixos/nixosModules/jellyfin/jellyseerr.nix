{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.jellyfin.jellyseerr;
in
{
  options.nixosModules.jellyfin.jellyseerr = {
    enable = mkEnableOption "Jellyseerr hosting";

    port = mkOption {
      type = types.port;
      default = 47140;
    };
  };

  config = mkIf cfg.enable {
    services.jellyseerr = {
      enable = true;
      port = cfg.port;
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
