{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.filebrowser;
in {
  options.nixosModules.filebrowser = {
    enable = lib.mkEnableOption "filebrowser web interface";
    port = lib.mkOption {
      type = lib.types.port;
      default = 47060;
    };

    ip = lib.mkOption {
      type = lib.types.string;
      default = config.nixosModules.info.system.ips.local;
    };

    directory = lib.mkOption {
      type = lib.types.string;
      default = "/mnt/server";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      filebrowser
    ];

    networking.firewall.allowedTCPPorts = [ cfg.port ];

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
