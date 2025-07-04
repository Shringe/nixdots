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
    sops.secrets."private/server" = {
      sopsFile = ./secrets.yaml;
    };

    environment.systemPackages = with pkgs; [
      (writeShellApplication {
        name = "wgnew";
        runtimeInputs = [
          wireguard-tools
          fish
        ];

        text = ''
          fish ${./wgnew.fish} \
            ${config.sops.secrets."private/server".path} \
            ${config.nixosModules.info.system.ips.local} \
            "wireguard.${config.nixosModules.reverseProxy.domain}" \
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

        privateKeyFile = config.sops.secrets."private/server".path;
      };
    };
  };
}
