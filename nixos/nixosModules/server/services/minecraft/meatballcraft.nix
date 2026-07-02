{
  config,
  lib,
  pkgs,
  ...
}:
let
  minecraft = config.nixosModules.server.services.minecraft;
  cfg = minecraft.meatballcraft;
in
{
  options.nixosModules.server.services.minecraft.meatballcraft = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = minecraft.enable;
    };

    directoryName = lib.mkOption {
      type = lib.types.str;
      default = "meatballcraft";
    };

    directory = lib.mkOption {
      type = lib.types.str;
      default = "${minecraft.directory}/${cfg.directoryName}";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "meatballcraft";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 25565;
    };

    voicechat = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 24454;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.directory} 0700 ${cfg.user} ${minecraft.group} -"
    ];

    users.users.${cfg.user} = {
      enable = true;
      isSystemUser = true;
      group = minecraft.group;
    };

    networking.firewall.allowedTCPPorts = [
      cfg.port
    ];

    networking.firewall.allowedUDPPorts = lib.mkIf cfg.voicechat.enable [
      cfg.voicechat.port
    ];

    systemd.services.minecraft-meatballcraft = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      startLimitIntervalSec = 60 * 30;
      startLimitBurst = 3;

      serviceConfig = {
        ExecStart = "${cfg.directory}/ServerStart.sh";
        WorkingDirectory = cfg.directory;
        User = cfg.user;
        Restart = "on-failure";
        Nice = 1;
      };

      path = with pkgs; [
        bash
        coreutils
        gnused
        gawk
        ncurses
        wget
        unixtools.ping
        zulu25
      ];
    };
  };
}
