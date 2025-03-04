{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.wireguard.server;
  interface = "enp42s0";
  private_ip = "10.100.0";
  port = 51820;
in
{
  config = lib.mkIf cfg.enable {
    networking = {
      nat = {
        enable = true;
        externalInterface = interface;
        internalInterfaces = [ "wg0" ];
      };

      firewall.allowedUDPPorts = [ port ];

      wireguard.interfaces.wg0 = {
        ips = [ "${private_ip}.1/24" ];
        listenPort = port;

        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${private_ip}.0/24 -o ${interface} -j MASQUERADE
        '';

        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${private_ip}.0/24 -o ${interface} -j MASQUERADE
        '';

        privateKeyFile = "/root/wireguard-keys/privatekey";
        generatePrivateKeyFile = true;

        peers = [
          { # My phone
            publicKey = "ltDO0r/WvwS8fnNa+zyiK5xEa1ZqSHLvtyrkIiUubn4=";
            allowedIPs = [ "${private_ip}.2/32" ];
          }
        ];
      };
    };
  };
}
