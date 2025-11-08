{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.server.ssh;
in {
  options.nixosModules.server.ssh = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.enable;
    };

    enableFail2ban = mkOption {
      type = types.bool;
      default = true;
    };

    host = mkOption {
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 22;
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.host}:${toString cfg.port}";
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };

      settings.AllowUsers = with config.nixosModules.users; []
        ++ optionals shringed.enable [ "shringed" ];
    };

    services.fail2ban = mkIf cfg.enableFail2ban {
      enable = true;
    };
  };
}
