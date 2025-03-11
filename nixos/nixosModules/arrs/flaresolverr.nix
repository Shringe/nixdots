{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.flaresolverr;
in {
  options.nixosModules.arrs.flaresolverr = {
    enable = mkEnableOption "Flaresolverr Cloudflare";
    port = mkOption {
      type = types.port;
      default = 43120;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.flaresolverr = {
      enable = true;
      port = cfg.port;
    };
  };
}
