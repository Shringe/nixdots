{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.shell.atuin.server;
in {
  options.nixosModules.shell.atuin.server = {
    enable = mkEnableOption "Enables atuin hosting";

    port = mkOption {
      type = types.port;
      default = 47200;
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://atuin.${config.nixosModules.reverseProxy.domain}";
    };
  };

  config = mkIf cfg.enable {
    services.atuin = {
      enable = true;
      host = config.nixosModules.info.system.ips.local;
      port = cfg.port;
      openRegistration = true;
      # openFirewall = true;
    };
  };
}
