{ config, lib, inputs, ... }:
with lib;
let
  cfg = config.nixosModules.gaming.servers.ase.Gatsby;
in {
  options.nixosModules.gaming.servers.ase.Gatsby = {
    enable = mkEnableOption "Sets up ASE server";

    ports = {
      game = mkOption {
        type = types.port;
        default = 7777;
      };

      rcon = mkOption {
        type = types.port;
        default = 27020;
      };

      query = mkOption {
        type = types.port;
        default = 27015;
      };
    };
  };

  config = mkIf cfg.enable {
    services.ark-server = {
      enable = true;
      sessionName = "Gatsby";
      serverPassword = "testme";
      adminPassword = "iamadmin";
      port = cfg.ports.game;
      queryPort = cfg.ports.query;
      rconPort = cfg.ports.rcon;

      map = "TheIsland";
      maxPlayers = 8;
    };
  };
}
