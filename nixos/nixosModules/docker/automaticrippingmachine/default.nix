{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.docker.automaticrippingmachine;
in {
  options.nixosModules.docker.automaticrippingmachine = {
    description = mkOption {
      type = types.string;
      default = "Automatically rips DVDs, Blu-rays, and CDs";
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    icon = mkOption {
      type = types.string;
      default = "cd.svg";
    };
  };

  config = mkIf cfg.enable {
    users.users.arm = {
      isNormalUser = true;
      extraGroups = [ "docker" ];
    };

    systemd.services.automaticrippingmachine = {
      description = "Automatic Ripping Machine Docker Service";
      after = [ "network.target" "docker.service" ];
      requires = [ "docker.service" ];
      wantedBy = [ ]; # This prevents it from starting automatically

      serviceConfig = {
        ExecStart = ''
          ${pkgs.docker}/bin/docker run --rm \
            -p ${toString cfg.port}:${toString cfg.port} \
            -e ARM_UID=1002 \
            -e ARM_GID=100 \
            -v /home/arm:/home/arm \
            -v /home/arm/music:/home/arm/music \
            -v /home/arm/logs:/home/arm/logs \
            -v /home/arm/media:/home/arm/media \
            -v /home/arm/config:/etc/arm/config \
            --device=/dev/sr0:/dev/sr0 \
            --privileged \
            --name arm-rippers \
            automaticrippingmachine/automatic-ripping-machine:latest
        '';

        User = "arm";
        ExecStop = "${pkgs.docker}/bin/docker stop arm-rippers";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
