{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nixosModules.wireguard.server;
in
{
  options.nixosModules.wireguard.server = {
    enable = mkEnableOption "wireguard hosting";
    port = mkOption {
      type = types.port;
      default = 47000;
    };

    private_ip = mkOption {
      type = types.string;
      default = "10.100.0";
    };

    interface = mkOption {
      type = types.string;
      default = "enp42s0";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."wireguard/server" = {};
    environment.systemPackages = with pkgs; [
      (writeShellApplication {
        name = "wgnew";
        runtimeInputs = [
          wireguard-tools
          fish
        ];

        text = ''
          fish ${./wgnew.fish} \
            ${config.sops.secrets."wireguard/server".path} \
            ${config.nixosModules.info.system.ips.local} \
            ${config.nixosModules.info.system.ips.public} \
            ${cfg.private_ip} \
            ${toString cfg.port} \
            "0.0.0.0/0" \
            "$1" \
            "$2"
        '';
      })
    ];

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

        privateKeyFile = config.sops.secrets."wireguard/server".path;

        peers = [
          # { # My phone
          #   # publicKey = "ltDO0r/WvwS8fnNa+zyiK5xEa1ZqSHLvtyrkIiUubn4=";
          #   publicKey = "Ferj3XiXDaAh3BAOznxIx7iVF+3MAjYfutPYJF9gGmA=";
          #   allowedIPs = [ "${cfg.private_ip}.2/32" ];
          # }
          { # K
            publicKey = "3HSS1loEZSCGjfqOLm/dyZpPfwzT31wKvw8Ygrl5czE=";
            allowedIPs = [ "${cfg.private_ip}.3/32" ];
          }
          { # My laptop
            publicKey = "D3qbFvDBUdQ1jJhvS2zUhiyi7hxikS4Y0PgLYUYkp3I=";
            allowedIPs = [ "${cfg.private_ip}.5/32" ];
          }
          { # New Phone
            publicKey = "kxDYZxPPhAQhgdd3u+/G0eJCiWhALGxmdKndjxTZXnw=";
            allowedIPs = [ "${cfg.private_ip}.6/32" ];
          }
        ];
      };
    };
  };
}
