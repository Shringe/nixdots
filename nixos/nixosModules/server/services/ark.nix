{
  config,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.server.services.ark;
in
{
  imports = [
    inputs.ark-server.nixosModule
  ];

  options.nixosModules.server.services.ark = {
    enable = mkOption {
      type = types.bool;
      # default = config.nixosModules.server.services.enable;
      default = false;
    };

    host = mkOption {
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."server/services/ark" = { };
    systemd.services.ark-server.serviceConfig.EnvironmentFile =
      config.sops.secrets."server/services/ark".path;

    services.ark-server = {
      enable = true; # Enable the ARK server

      user = "steam"; # User under which the server runs
      serverDir = "/home/steam/servers/ark"; # Server installation directory

      # Server Settings
      sessionName = "My Test Ark Server"; # Server name shown in browser
      # adminPassword = "adminpass"; # Admin password for remote administration
      # serverPassword = "serverpass"; # Password to join the server
      adminPassword = "$ARK_ADMINPASS";
      serverPassword = "$ARK_SERVERPASS";
      map = "TheIsland"; # Map to run
      maxPlayers = 4; # Maximum number of players

      # Network Settings
      port = 7777; # Main server port
      queryPort = 27015; # Query port for server browser
      rconPort = 27020; # RCON port for remote administration

      # Gameplay Settings
      mods = ""; # Comma-separated list of mod IDs
      ServerCrosshair = "True"; # Enable/disable crosshair
      AllowThirdPersonPlayer = "True"; # Enable/disable third person view
      ShowMapPlayerLocation = "True"; # Show player location on map
      ServerPVE = "True"; # Enable PVE mode
    };
  };
}
