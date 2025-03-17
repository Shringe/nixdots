{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.flaresolverr;
in {
  options.nixosModules.arrs.flaresolverr = {
    enable = mkEnableOption "Flaresolverr Cloudflare";

    ip = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 43120;
    };

    description = mkOption {
      type = types.string;
      default = "Bypasses Cloudflare Protection";
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.ip}:${toString cfg.port}";
    };
  };

  config = mkIf cfg.enable {
    services.flaresolverr = {
      enable = true;
      port = cfg.port;
      openFirewall = true;
    };
  };
}
