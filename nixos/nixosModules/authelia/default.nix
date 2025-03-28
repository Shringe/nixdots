{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.authelia;
in {
  options.nixosModules.authelia = {
    enable = mkEnableOption "Authelia setup";
  };

  config = mkIf cfg.enable {
    services.authelia = {
      # enable = true;
    };
  };
}
