# Modified version of https://codeberg.org/MachsteNix/ark-survival-evolved-nix/src/branch/main/flake.nix
{ config, lib, pkgs, ... }:
with lib; let
  # Short-hand reference to the module's configuration
  cfg = config.services.ark-server;
in {
  imports = [
    ./Gatsby.nix
  ];

  # Module configuration options
  options.services.ark-server = {
    # Basic server settings
    enable = mkEnableOption "ARK Survival Evolved server";

    user = mkOption {
      type = types.str;
      default = "steam";
      description = "User under which the server runs";
    };

    serverDir = mkOption {
      type = types.path;
      default = "/home/steam/servers/ark";
      description = "ARK server installation directory";
    };

    # Server identification settings
    sessionName = mkOption {
      type = types.str;
      default = "My Ark Server";
      description = "Server session name";
    };

    # Security settings
    adminPassword = mkOption {
      type = types.str;
      default = "PASSWORD";
      description = "Server admin password";
    };

    serverPassword = mkOption {
      type = types.str;
      default = "password";
      description = "Server password";
    };

    # Game settings
    map = mkOption {
      type = types.str;
      default = "TheIsland";
      description = "Map to run";
    };

    maxPlayers = mkOption {
      type = types.int;
      default = 70;
      description = "Maximum number of players";
    };

    # Network settings
    port = mkOption {
      type = types.int;
      default = 7777;
      description = "Server port";
    };

    queryPort = mkOption {
      type = types.int;
      default = 27015;
      description = "Query port";
    };

    rconPort = mkOption {
      type = types.int;
      default = 27020;
      description = "RCON port";
    };

    # Mod support
    mods = mkOption {
      type = types.str;
      default = "";
      description = "Comma-separated list of mod IDs";
    };

    # Gameplay options
    ServerCrosshair = mkOption {
      type = types.str;
      default = "True";
      description = "Enable/disable crosshair (True/False)";
    };

    AllowThirdPersonPlayer = mkOption {
      type = types.str;
      default = "True";
      description = "Enable/disable third person view (True/False)";
    };

    ShowMapPlayerLocation = mkOption {
      type = types.str;
      default = "True";
      description = "Show/hide player location on map (True/False)";
    };

    ServerPVE = mkOption {
      type = types.str;
      default = "True";
      description = "Enable/disable PVE mode (True/False)";
    };
  };

  # Module implementation
  config = mkIf cfg.enable {
    # System configuration
    boot.kernel.sysctl = {
      # Enable user namespaces for Steam
      "kernel.unprivileged_userns_clone" = 1;
      # Increase maximum file handles
      "fs.file-max" = 100000;
    };

    # User and group configuration
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.user;
      home = "/home/${cfg.user}";
      createHome = true;
    };

    users.groups.${cfg.user} = {};

    # System resource limits
    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "1000000";
      }
      {
        domain = "*";
        type = "hard";
        item = "nofile";
        value = "1000000";
      }
    ];

    # Systemd service configuration
    systemd.services.ark-server = {
      description = "ARK Survival Evolved Server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      # Server preparation script
      preStart = ''
        # Create required directories
        mkdir -p "/home/${cfg.user}/.steam"
        mkdir -p "/home/${cfg.user}/.local/share/Steam"
        mkdir -p "${cfg.serverDir}"

        # Set directory permissions
        chown -R ${cfg.user}:${cfg.user} "/home/${cfg.user}/.steam"
        chown -R ${cfg.user}:${cfg.user} "/home/${cfg.user}/.local"
        chown -R ${cfg.user}:${cfg.user} "${cfg.serverDir}"

        # Initialize Steam
        HOME="/home/${cfg.user}" ${pkgs.steam-run}/bin/steam-run ${pkgs.steamcmd}/bin/steamcmd +quit || true

        # Install/Update ARK Server
        HOME="/home/${cfg.user}" ${pkgs.steam-run}/bin/steam-run ${pkgs.steamcmd}/bin/steamcmd \
          +force_install_dir "${cfg.serverDir}" \
          +login anonymous \
          +app_update 376030 validate \
          +quit

        # Update permissions after installation
        chown -R ${cfg.user}:${cfg.user} "${cfg.serverDir}"
      '';

      # Service runtime configuration
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.user;
        Environment = "HOME=/home/${cfg.user}";
        # Server start command with all parameters
        ExecStart = pkgs.writeShellScript "ark-server-start" ''
          cd "${cfg.serverDir}/ShooterGame/Binaries/Linux"
          ${pkgs.steam-run}/bin/steam-run ./ShooterGameServer \
          "${cfg.map}?listen\
          ?SessionName=${cfg.sessionName}\
          ?ServerPassword=${cfg.serverPassword}\
          ?ServerAdminPassword=${cfg.adminPassword}\
          ?MaxPlayers=${toString cfg.maxPlayers}\
          ?Port=${toString cfg.port}\
          ?QueryPort=${toString cfg.queryPort}\
          ?RCONPort=${toString cfg.rconPort}\
          ?ServerCrosshair=${cfg.ServerCrosshair}\
          ?AllowThirdPersonPlayer=${cfg.AllowThirdPersonPlayer}\
          ?ShowMapPlayerLocation=${cfg.ShowMapPlayerLocation}\
          ?ServerPVE=${cfg.ServerPVE}\
          ?ModIds=${cfg.mods}" \
          -server \
          -log \
          -servergamelog \
          -crossplay \
          -automanagedmods \
          -NoBattlEye
        '';

        # Service restart configuration
        Restart = "always";
        RestartSec = "10";
        # Working directory configuration
        WorkingDirectory = "${cfg.serverDir}";
        StateDirectory = "ark-server";
        RuntimeDirectory = "ark-server";
        UMask = "0022";
      };
    };

    # Required system packages
    environment.systemPackages = with pkgs; [
      steamcmd    # Steam CMD for server installation
      steam-run  # Steam runtime environment
      glibc      # Required libraries
      gcc        # Required for some Steam operations
    ];

    # Firewall configuration
    networking.firewall.allowedTCPPorts = [cfg.port cfg.queryPort cfg.rconPort];
    networking.firewall.allowedUDPPorts = [cfg.port cfg.queryPort cfg.rconPort];
  };
}
