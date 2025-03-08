{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.guacamole;
in {
  options.nixosModulet.guacamole = {
    enable = mkEnableOption "Guacamole web interface";

    port = mkOption {
      type = types.port;
      default = 47160;
    };
  };

  config = mkIf cfg.enable {
    services.guacamole-server = {
      enable = true;
      port = cfg.port;
    };
  };
}
