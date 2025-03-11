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
  };

  config = mkIf cfg.enable {
    services.atuin = {
      enable = true;
      host = config.nixosModules.info.system.ips.local;
      port = cfg.port;
      openRegistration = true;
      openFirewall = true;
    };
  };
}
