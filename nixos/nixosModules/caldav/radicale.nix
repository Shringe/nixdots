{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.caldav.radicale;
in {
  options.nixosModules.caldav.radicale = {
    enable = mkEnableOption "Radicale hosting";

    ip = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default =  47220;
    };
  };

  config = mkIf cfg.enable {
    # sops.secrets."caldav/radicale/server" = {};
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.radicale = {
      enable = true;
      settings = {
        server = {
          hosts = [ "${cfg.ip}:${toString cfg.port}" ];
        };

        # auth = {
        #   type = "htpasswd";
        #   # htpasswd_filename = config.sops.secrets."caldav/radicale/server".path;
        #   # htpasswd_filename = "/tmp/radicale";
        #   # htpasswd_filename = "/etc/radicale/users";
        #   htpasswd_encryption = "bcrypt";
        # };
      };
    };
  };
}
