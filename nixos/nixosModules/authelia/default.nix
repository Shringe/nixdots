{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.authelia;
  domain = config.nixosModules.reverseProxy.domain;
in {
  options.nixosModules.authelia = {
    enable = mkEnableOption "Authelia setup";

    port = mkOption {
      type = types.port;
      default = 9091;
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://auth.${config.nixosModules.reverseProxy.domain}";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "authelia/jwt" = { owner = "authelia-main"; };
      "authelia/storageEncryption" = { owner = "authelia-main"; };
      "authelia/users_database" = { owner = "authelia-main"; };
    };

    services = {
      authelia.instances.main = {
        enable = true;
        secrets = with config.sops; {
          jwtSecretFile = secrets."authelia/jwt".path;
          storageEncryptionKeyFile = secrets."authelia/storageEncryption".path;
          # Only used for redis
          # sessionSecretFile = secrets."authelia/session".path;
        };

        settings = {
          authentication_backend.file.path = config.sops.secrets."authelia/users_database".path;
          # server.address = cfg.furl;

          access_control = {
            default_policy = "deny";
            
            rules = [
              {
                domain = "*.${domain}";
                policy = "one_factor";
              }
            ];
          };

          session = {
            cookies = [
              {
                name = "authelia_session";
                domain = domain;
                authelia_url = cfg.furl;
                expiration = "1 hour";
                inactivity = "5 minutes";
              }
            ];
          };

          # redis here?

          regulation = {
            max_retries = 5;
            find_time = "2 minutes";
            ban_time = "5 minutes";
          };

          storage.local.path = "/var/lib/authelia-main/db.sqlite3";
          notifier.filesystem.filename = "/var/lib/authelia-main/notification.txt";
        };
      };

      caddy = {
        virtualHosts."auth.${domain}".extraConfig = ''
          reverse_proxy :${toString cfg.port}
        '';

        # A Caddy snippet that can be imported to enable Authelia in front of a service
        # Taken from https://www.authelia.com/integration/proxies/caddy/#subdomain
        # extraConfig = ''
        #   (auth) {
        #       forward_auth :${cfg.port} {
        #           uri /api/authz/forward-auth
        #           copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
        #       }
        #   }
        # '';
      };
    };
  };
}
