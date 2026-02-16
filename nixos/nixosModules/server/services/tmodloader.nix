{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.server.services.tmodloader;
  domain = config.nixosModules.reverseProxy.domain;
  secret = "server/services/tmodloader_serverconfig_txt";
  server = ''${pkgs.steam-run}/bin/steam-run /mnt/Steam/libraries/SSD3/SteamLibrary/steamapps/common/tModLoader/start-tModLoaderServer.sh -nosteam -config "${
    config.sops.secrets.${secret}.path
  }"'';
in
{
  options.nixosModules.server.services.tmodloader = {
    enable = mkOption {
      type = types.bool;
      default = false;
      # default = config.nixosModules.server.services.enable;
    };

    host = mkOption {
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 47520;
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://tmodloader.${domain}";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    sops.secrets.${secret} = {
      owner = config.users.users.shringed.name;
    };

    systemd.services.tmodloader = {
      after = [
        "network-online.target"
      ];
      wants = [
        "network-online.target"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = server;
        Restart = "always";
        User = "shringed";
        # StandardInput = "file:/var/run/tmodloader.stdin";
        # ExecStartPre = "${pkgs.coreutils}/bin/mkfifo /var/run/tmodloader.stdin";
        # ExecStopPost = "${pkgs.coreutils}/bin/rm /var/run/tmodloader.stdin";
      };
    };
  };
}
