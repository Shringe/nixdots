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

    systemd.services.minecraft-meatballcraft = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash ${cfg.directory}/start.sh";
        WorkingDirectory = cfg.directory;
        User = cfg.user;
        Restart = "on-failure";
      };

      startLimitIntervalSec = 300;
      startLimitBurst = 5;
    };
  };
}
