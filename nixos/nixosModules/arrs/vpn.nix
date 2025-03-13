{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs.vpn;
in {
  options.nixosModules.arrs.vpn = {
    enable = mkEnableOption "Confines *arrs to a vpn";
  };

  config = mkIf cfg.enable {
    nixosModules.homepage.vpnIp = "192.168.15.1";
    
    vpnNamespaces.airvpn.portMappings = [
      {
        from = config.nixosModules.arrs.sonarr.port;
        to = config.nixosModules.arrs.sonarr.port;
        protocol = "tcp";
      }
      {
        from = config.nixosModules.arrs.radarr.port;
        to = config.nixosModules.arrs.radarr.port;
        protocol = "tcp";
      }
      {
        from = config.nixosModules.arrs.lidarr.port;
        to = config.nixosModules.arrs.lidarr.port;
        protocol = "tcp";
      }
      {
        from = config.nixosModules.arrs.prowlarr.port;
        to = config.nixosModules.arrs.prowlarr.port;
        protocol = "tcp";
      }
      {
        from = config.nixosModules.arrs.flaresolverr.port;
        to = config.nixosModules.arrs.flaresolverr.port;
        protocol = "tcp";
      }
    ];

    systemd.services = {
      sonarr.vpnConfinement = {
        enable = true;
        vpnNamespace = "airvpn";
      };

      radarr.vpnConfinement = {
        enable = true;
        vpnNamespace = "airvpn";
      };

      lidarr.vpnConfinement = {
        enable = true;
        vpnNamespace = "airvpn";
      };

      prowlarr.vpnConfinement = {
        enable = true;
        vpnNamespace = "airvpn";
      };

      flaresolverr.vpnConfinement = {
        enable = true;
        vpnNamespace = "airvpn";
      };
    };
  };
}
