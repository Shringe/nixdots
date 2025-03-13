{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.torrent.qbittorrent;
in {
  options.nixosModules.torrent.qbittorrent = {
    enable = mkEnableOption "qBittorrent";
    ports = {
      webui = mkOption {
        type = types.port;
        default = 43080;
      };

      traffic = mkOption {
        type = types.port;
        default = 16403;
      };
    };

    ips = {
      webui = mkOption {
        type = types.string;
        default = "192.168.15.1";
      };
    };
  };

  config = mkIf cfg.enable {
    # networking.firewall.allowedTCPPorts = [ cfg.ports.webui cfg.ports.traffic ];
    # networking.firewall.allowedUDPPorts = [ cfg.ports.traffic ];

    sops.secrets."user_passwords/qbittorrent".neededForUsers = true;
    users.users.qbittorrent = {
      isNormalUser = true;
      group = "qbittorrent";
      hashedPasswordFile = config.sops.secrets."user_passwords/qbittorrent".path;
    };

    users.groups.qbittorrent = {};

    systemd.services.qbittorrent = {
      description = "qBittorrent-nox service";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" "nss-lookup.target" ];

      serviceConfig = {
        Type = "exec";
        User = "qbittorrent";
        Group = "qbittorrent";
        ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=${toString cfg.ports.webui}";
      };

      wantedBy = [ "multi-user.target" ];

      vpnConfinement = {
        enable = true;
        vpnNamespace = "airvpn";
      };
    };
  };
}
