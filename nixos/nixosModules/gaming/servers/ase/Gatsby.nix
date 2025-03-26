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
      serverPassword = "5253";
      adminPassword = "277353";
      port = cfg.ports.game;
      queryPort = cfg.ports.query;
      rconPort = cfg.ports.rcon;

      serverDir = "/home/steam/servers/ark";
      # mods = "1931415003,609425335,1404697612,2967051050,1522327484,1445395055,1565015734,1650069767,751991809,2804332920,821530042,731604991,2064588662,2920747753";
      map = "TheIsland";
      maxPlayers = 8;
    };
  };
}
