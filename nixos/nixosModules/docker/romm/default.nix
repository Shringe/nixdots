# Auto-generated using compose2nix v0.3.1.
{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.nixosModules.docker.romm;

  ip = config.nixosModules.info.system.ips.local;
in {
  options.nixosModules.docker.romm = {
    enable = mkEnableOption "Romm";

    directory = mkOption {
      type = types.string;
      default = "/mnt/server/Emulation/romm";
    };

    port = mkOption {
      type = types.port;
      default = 41020;
    };

    description = mkOption {
      type = types.string;
      default = "RomM Emulator and Rom Manager";
    };

    url = mkOption {
      type = types.string;
      default = "http://${ip}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://romm.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "romm.svg";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "romm/romm" = {};
      "romm/db" = {};
    };

    # Containers
    virtualisation.oci-containers.containers."romm" = {
      image = "rommapp/romm:latest";
      environmentFiles = [ config.sops.secrets."romm/romm".path ];

      # environment = {
      #   "DB_HOST" = "romm-db";
      #   "DB_NAME" = "romm";
      #   "DB_PASSWD" = "";
      #   "DB_USER" = "romm-user";
      #   "IGDB_CLIENT_ID" = "";
      #   "IGDB_CLIENT_SECRET" = "";
      #   "ROMM_AUTH_SECRET_KEY" = "";
      #   "SCREENSCRAPER_PASSWORD" = "";
      #   "SCREENSCRAPER_USER" = "";
      #   "STEAMGRIDDB_API_KEY" = "";
      # };

      volumes = [
        "${cfg.directory}/assets:/romm/assets:rw"
        "${cfg.directory}/config:/romm/config:rw"
        "${cfg.directory}/library:/romm/library:rw"
        "romm_romm_redis_data:/redis-data:rw"
        "romm_romm_resources:/romm/resources:rw"
      ];

      ports = [
        "${ip}:${toString cfg.port}:8080/tcp"
      ];

      dependsOn = [
        "romm-db"
      ];

      log-driver = "journald";
      extraOptions = [
        "--network-alias=romm"
        "--network=romm_default"
      ];
    };

    systemd.services."docker-romm" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
        RestartMaxDelaySec = lib.mkOverride 90 "1m";
        RestartSec = lib.mkOverride 90 "100ms";
        RestartSteps = lib.mkOverride 90 9;
      };

      after = [
        "docker-network-romm_default.service"
        "docker-volume-romm_romm_redis_data.service"
        "docker-volume-romm_romm_resources.service"
      ];

      requires = [
        "docker-network-romm_default.service"
        "docker-volume-romm_romm_redis_data.service"
        "docker-volume-romm_romm_resources.service"
      ];

      partOf = [
        "docker-compose-romm-root.target"
      ];

      wantedBy = [
        "docker-compose-romm-root.target"
      ];
    };

    virtualisation.oci-containers.containers."romm-db" = {
      image = "mariadb:latest";
      environmentFiles = [ config.sops.secrets."romm/db".path ];

      # environment = {
      #   "MARIADB_DATABASE" = "romm";
      #   "MARIADB_PASSWORD" = "";
      #   "MARIADB_ROOT_PASSWORD" = "";
      #   "MARIADB_USER" = "romm-user";
      # };

      volumes = [
        "romm_mysql_data:/var/lib/mysql:rw"
      ];

      log-driver = "journald";
      extraOptions = [
        "--health-cmd=[\"healthcheck.sh\", \"--connect\", \"--innodb_initialized\"]"
        "--health-interval=10s"
        "--health-retries=5"
        "--health-start-interval=10s"
        "--health-start-period=30s"
        "--health-timeout=5s"
        "--network-alias=romm-db"
        "--network=romm_default"
      ];
    };

    systemd.services."docker-romm-db" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
        RestartMaxDelaySec = lib.mkOverride 90 "1m";
        RestartSec = lib.mkOverride 90 "100ms";
        RestartSteps = lib.mkOverride 90 9;
      };

      after = [
        "docker-network-romm_default.service"
        "docker-volume-romm_mysql_data.service"
      ];

      requires = [
        "docker-network-romm_default.service"
        "docker-volume-romm_mysql_data.service"
      ];

      partOf = [
        "docker-compose-romm-root.target"
      ];

      wantedBy = [
        "docker-compose-romm-root.target"
      ];
    };

    # Networks
    systemd.services."docker-network-romm_default" = {
      path = [ pkgs.docker ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "docker network rm -f romm_default";
      };

      script = ''
        docker network inspect romm_default || docker network create romm_default
      '';

      partOf = [ "docker-compose-romm-root.target" ];
      wantedBy = [ "docker-compose-romm-root.target" ];
    };

    # Volumes
    systemd.services."docker-volume-romm_mysql_data" = {
      path = [ pkgs.docker ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        docker volume inspect romm_mysql_data || docker volume create romm_mysql_data
      '';

      partOf = [ "docker-compose-romm-root.target" ];
      wantedBy = [ "docker-compose-romm-root.target" ];
    };

    systemd.services."docker-volume-romm_romm_redis_data" = {
      path = [ pkgs.docker ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        docker volume inspect romm_romm_redis_data || docker volume create romm_romm_redis_data
      '';

      partOf = [ "docker-compose-romm-root.target" ];
      wantedBy = [ "docker-compose-romm-root.target" ];
    };

    systemd.services."docker-volume-romm_romm_resources" = {
      path = [ pkgs.docker ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        docker volume inspect romm_romm_resources || docker volume create romm_romm_resources
      '';

      partOf = [ "docker-compose-romm-root.target" ];
      wantedBy = [ "docker-compose-romm-root.target" ];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."docker-compose-romm-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
