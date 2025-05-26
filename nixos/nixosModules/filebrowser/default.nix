{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.filebrowser;
in {
  options.nixosModules.filebrowser = {
    enable = mkEnableOption "filebrowser web interface";
    port = mkOption {
      type = types.port;
      default = 47060;
    };

    ip = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };

    directory = mkOption {
      type = types.string;
      default = "/mnt/server";
    };

    description = mkOption {
      type = types.string;
      default = "Cloud Storage and Filesharing";
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.ip}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://files.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "filebrowser.svg";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      filebrowser
    ];

    # Used for filebrowser mutability
    users.users.filebrowser = {
      isNormalUser = true;
      initialPassword = "123";
    };

    systemd.services.filebrowser = {
      description = "File Browser Service";
      after = [ "network.target" "mnt-server.mount" ];
      wants = [ "mnt-server.mount" ];
      
      serviceConfig = {
        ExecStart = ''
          ${pkgs.filebrowser}/bin/filebrowser \
            --root ${cfg.directory} \
            --address ${cfg.ip} \
            --port ${toString cfg.port} \
            --database ${cfg.directory}/filebrowser.db \
            --disable-exec
        '';
        Restart = "always";
        User = "filebrowser";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
