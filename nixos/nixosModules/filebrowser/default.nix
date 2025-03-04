{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.filebrowser;
  directory = "/mnt/server";
  ip = "192.168.0.165";
  port = 8080;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      filebrowser
    ];

    networking.firewall = {
      allowedTCPPorts = [ port ];
      allowedUDPPorts = [ port ];
    };

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
            --root ${directory} \
            --address ${ip} \
            --port ${toString port} \
            --database ${directory}/filebrowser.db \
            --disable-exec
        '';
        Restart = "always";
        User = "filebrowser";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
