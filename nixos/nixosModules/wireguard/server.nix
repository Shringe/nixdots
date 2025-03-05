{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.wireguard.server;
in
{
  config = lib.mkIf cfg.enable {
    networking = {
      nat = {
        enable = true;
        externalInterface = cfg.interface;
        internalInterfaces = [ "wg0" ];
      };

      firewall.allowedUDPPorts = [ cfg.port ];

      wireguard.interfaces.wg0 = {
        ips = [ "${cfg.private_ip}.1/24" ];
        listenPort = cfg.port;

        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${cfg.private_ip}.0/24 -o ${cfg.interface} -j MASQUERADE
        '';

        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${cfg.private_ip}.0/24 -o ${cfg.interface} -j MASQUERADE
        '';

        privateKeyFile = "/root/wireguard-keys/privatekey";
        generatePrivateKeyFile = true;

        peers = [
          { # My phone
            publicKey = "ltDO0r/WvwS8fnNa+zyiK5xEa1ZqSHLvtyrkIiUubn4=";
            allowedIPs = [ "${cfg.private_ip}.2/32" ];
          }
          { # K
            publicKey = "3HSS1loEZSCGjfqOLm/dyZpPfwzT31wKvw8Ygrl5czE=";
            allowedIPs = [ "${cfg.private_ip}.3/32" ];
          }
        ];
      };
    };
  };
}
