{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.ssh.server;
in {
  options.nixosModules.ssh.server = {
    enable = mkEnableOption "OpenSSH server";

    port = mkOption {
      type = types.port;
      default = 22;
    };

    enableFail2ban = mkEnableOption "Fail2ban SSH";
  };

  config = mkIf cfg.enable {
    nixosModules.ssh.server.enableFail2ban = mkDefault true;

    services.openssh = {
      enable = true;
      listenAddresses = [
        {
          addr = config.nixosModules.info.system.ips.local;
          port = cfg.port;
        }
      ];

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
