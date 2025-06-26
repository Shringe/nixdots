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
      # Example:
      # [Interface]
      # PrivateKey = WGpL3/ejM5L9ngLoAtXkSP1QTNp4eSD34Zh6/Jfni1Q=
      # ListenPort = 51820
      # DNS = 10.6.210.1, pfSense.home.arpa
      # Address = 10.6.210.2/24
      #
      # [Peer]
      # PublicKey = PUVBJ+zuz/0mRPEB4tIaVbet5NzVwdWMX7crGx+/wDs=
      # AllowedIPs = 0.0.0.0/0
      # Endpoint = 198.51.100.6:51820

      (writers.writeFishBin "wgnew" ''
        # set server_private_key (cat "${config.sops.secrets."wireguard/server".path}") 
        # set server_private_key ""

        function is_debug_mode
          if test "$argv[1]" = "--debug"
            true
          else
            false
          end
        end

        echo (is_debug_mode $argv)
      '')

      (writeShellApplication {
        name = "wgnew-sh";
        runtimeInputs = [
          openssl
          wireguard-tools
        ];

        text = ''
          # serverPrivateKey
          echo hello!
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
          { # My phone
            # publicKey = "ltDO0r/WvwS8fnNa+zyiK5xEa1ZqSHLvtyrkIiUubn4=";
            publicKey = "Ferj3XiXDaAh3BAOznxIx7iVF+3MAjYfutPYJF9gGmA=";
            allowedIPs = [ "${cfg.private_ip}.2/32" ];
          }
          { # K
            publicKey = "3HSS1loEZSCGjfqOLm/dyZpPfwzT31wKvw8Ygrl5czE=";
            allowedIPs = [ "${cfg.private_ip}.3/32" ];
          }
          { # Sam PC
            publicKey = "7V6HsDx5pYjQMht9Wq2uFZuw3OPfICZIiIPcfhcyM3U=";
            allowedIPs = [ "${cfg.private_ip}.4/32" ];
          }
          { # My laptop
            publicKey = "D3qbFvDBUdQ1jJhvS2zUhiyi7hxikS4Y0PgLYUYkp3I=";
            allowedIPs = [ "${cfg.private_ip}.5/32" ];
          }
          # { # Preshared my phone
          #   publicKey = 
          #   allowedIPs = [ "${cfg.private_ip}.6/32" ];
          # }
        ];
      };
    };
  };
}
