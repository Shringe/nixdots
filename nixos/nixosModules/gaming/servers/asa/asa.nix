# https://github.com/Acekorneya/Ark-Survival-Ascended-Server
# ABANDONED
{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.gaming.servers.asa;
in {
  options.nixosModules.gaming.servers.asa = {
    enable = mkEnableOption "Partially sets up ASA server permissions and user";
    openFirewall = mkEnableOption "Opens game and firewall ports";

    ports = {
      game = mkOption {
        type = types.port;
        default = 7777;
      };

      rcon = mkOption {
        type = types.port;
        default = 27020;
      };
    };
  };

  config = mkIf cfg.enable {
    nixosModules = {
      gaming.servers = {
        steam.enable = mkDefault true;

        asa = {
          openFirewall = mkDefault true;
        };
      };

      docker.enable = mkDefault true;
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.ports.game cfg.ports.rcon ];
      allowedUDPPorts = [ cfg.ports.game ];
    };
  };
}
