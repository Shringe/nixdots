{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.server.services.whalecrab;
in
{
  options.nixosModules.server.services.whalecrab = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
      description = "Runs whalecrab under lichess-bot";
    };

    directory = mkOption {
      type = types.str;
      default = "/mnt/server/critical/whalecrab";
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.directory} 0700 whalecrab whalecrab -"
      "d ${cfg.directory}/engines 0700 whalecrab whalecrab -"
      "L+ ${cfg.directory}/engines/whalecrab - - - - ${pkgs.whalecrab_uci}/bin/uci"
    ];

    users.groups.whalecrab = { };
    users.users.whalecrab = {
      enable = true;
      isSystemUser = true;
      group = "whalecrab";
    };

    systemd.services.whalecrab = {
      description = "Runs whalecrab through lichess-bot";
      after = [
        "network-online.target"
        "mnt-server.mount"
      ];
      wants = [
        "network-online.target"
        "mnt-server.mount"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart =
          let
            python = pkgs.python3.withPackages (
              ppkgs: with ppkgs; [
                chess
                pyyaml
                backoff
                rich
                requests
              ]
            );
          in
          "${python}/bin/python lichess-bot.py";
        WorkingDirectory = cfg.directory;
        Restart = "always";
        User = "whalecrab";
      };

      environment = {
        PYTHONUNBUFFERED = "1";
      };
    };
  };
}
