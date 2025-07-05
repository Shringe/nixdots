{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.vpn.nordvpn;
in {
  options.nixosModules.vpn.nordvpn = {
    enabled = mkEnableOption "nordvpnd daemon";
  };

  # config = mkIf cfg.enabled {
  #   networking.firewall.checkReversePath = false;
  #
  #   environment.systemPackages = [pkg];
  #
  #   users.groups.nordvpn = {};
  #   # users.groups.nordvpn.members = ["myypo"];
  #
  #   systemd = {
  #     services.nordvpn = {
  #       description = "NordVPN daemon.";
  #       serviceConfig = {
  #         ExecStart = "${pkg}/bin/nordvpnd";
  #         ExecStartPre = pkgs.writeShellScript "nordvpn-start" ''
  #           mkdir -m 700 -p /var/lib/nordvpn;
  #           if [ -z "$(ls -A /var/lib/nordvpn)" ]; then
  #             cp -r ${pkg}/var/lib/nordvpn/* /var/lib/nordvpn;
  #           fi
  #         '';
  #         NonBlocking = true;
  #         KillMode = "process";
  #         Restart = "on-failure";
  #         RestartSec = 5;
  #         RuntimeDirectory = "nordvpn";
  #         RuntimeDirectoryMode = "0750";
  #         Group = "nordvpn";
  #       };
  #       wantedBy = ["multi-user.target"];
  #       after = ["network-online.target"];
  #       wants = ["network-online.target"];
  #     };
  #   };
  # };
}
