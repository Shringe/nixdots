{ config, lib, inputs, ... }:
with lib;
let
  cfg = config.nixosModules.vpn.airvpn;
in {
  imports = [
    inputs.vpn-confinement.nixosModules.default
  ];

  options.nixosModules.vpn.airvpn = {
    enable = mkEnableOption "Airvpn confinement";
  };

  config = mkIf cfg.enable {
    sops.secrets."wireguard/airvpn" = {};
    vpnNamespaces.airvpn = {
      enable = true;
      wireguardConfigFile = config.sops.secrets."wireguard/airvpn".path;
      accessibleFrom = [
        "192.168.0.165"
      ];

      portMappings = [
        {
          from = config.nixosModules.torrent.qbittorrent.ports.webui;
          to = config.nixosModules.torrent.qbittorrent.ports.webui;
        }
      ];

      openVPNPorts = [
        {
          port = config.nixosModules.torrent.qbittorrent.ports.traffic;
          protocol = "both";
        }
      ];
    };
  };
}
