{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.ssh.server;
in {
  options.nixosModules.ssh.server = {
    enable = mkEnableOption "OpenSSH server";

    port = mkOption {
      type = types.port;
      default = 5253;
    };

    enableFail2ban = mkEnableOption "Fail2ban SSH";
  };

  config = mkIf cfg.enable {
    nixosModules.ssh.server.enableFail2ban = mkDefault true;

    services.openssh = {
      enable = true;
      ports = [ cfg.port ];

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    services.fail2ban = mkIf cfg.enableFail2ban {
      enable = true;
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
