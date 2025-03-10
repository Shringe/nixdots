{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.torrent.qbittorrent;
in {
  options.nixosModules.torrent.qbittorrent = {
    enable = mkEnableOption "qBittorrent";
    port = mkOption {
      type = types.port;
      default = 43080;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qbittorrent
    ];

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    systemd.services.qbittorrent = {
      description = "qBittorrent-nox service";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" "nss-lookup.target" ];

      serviceConfig = {
        Type = "exec";
        User = "jsparrow";
        ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=${toString cfg.port}";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
