# Auto-generated using compose2nix v0.3.1.
{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.nixosModules.docker.romm;
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
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://romm.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "jellyfin.svg";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "romm/romm" = {};
      "romm/db" = {};
    };

    # Runtime
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;

      defaultNetwork.settings = {
        # Required for container networking to be able to use names.
        dns_enabled = true;
      };
    };

    # Enable container name DNS for non-default Podman networks.
    # https://github.com/NixOS/nixpkgs/issues/226365
    networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

    virtualisation.oci-containers.backend = "podman";

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
        # "80:8080/tcp"
        "${toString cfg.port}/tcp"
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

    systemd.services."podman-romm" = {
      serviceConfig = {
        Restart = mkOverride 90 "always";
      };

      after = [
        "podman-network-romm_default.service"
        "podman-volume-romm_romm_redis_data.service"
        "podman-volume-romm_romm_resources.service"
      ];

      requires = [
        "podman-network-romm_default.service"
        "podman-volume-romm_romm_redis_data.service"
        "podman-volume-romm_romm_resources.service"
      ];

      partOf = [
        "podman-compose-romm-root.target"
      ];

      wantedBy = [
        "podman-compose-romm-root.target"
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
        "--health-start-period=30s"
        "--health-startup-interval=10s"
        "--health-timeout=5s"
        "--network-alias=romm-db"
        "--network=romm_default"
      ];
    };

    systemd.services."podman-romm-db" = {
      serviceConfig = {
        Restart = mkOverride 90 "always";
      };

      after = [
        "podman-network-romm_default.service"
        "podman-volume-romm_mysql_data.service"
      ];

      requires = [
        "podman-network-romm_default.service"
        "podman-volume-romm_mysql_data.service"
      ];

      partOf = [
        "podman-compose-romm-root.target"
      ];

      wantedBy = [
        "podman-compose-romm-root.target"
      ];
    };

    # Networks
    systemd.services."podman-network-romm_default" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f romm_default";
      };
      script = ''
        podman network inspect romm_default || podman network create romm_default
      '';
      partOf = [ "podman-compose-romm-root.target" ];
      wantedBy = [ "podman-compose-romm-root.target" ];
    };

    # Volumes
    systemd.services."podman-volume-romm_mysql_data" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        podman volume inspect romm_mysql_data || podman volume create romm_mysql_data
      '';

      partOf = [ "podman-compose-romm-root.target" ];
      wantedBy = [ "podman-compose-romm-root.target" ];
    };

    systemd.services."podman-volume-romm_romm_redis_data" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        podman volume inspect romm_romm_redis_data || podman volume create romm_romm_redis_data
      '';

      partOf = [ "podman-compose-romm-root.target" ];
      wantedBy = [ "podman-compose-romm-root.target" ];
    };

    systemd.services."podman-volume-romm_romm_resources" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        podman volume inspect romm_romm_resources || podman volume create romm_romm_resources
      '';

      partOf = [ "podman-compose-romm-root.target" ];
      wantedBy = [ "podman-compose-romm-root.target" ];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."podman-compose-romm-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
