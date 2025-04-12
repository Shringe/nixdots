{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.boot.displayManagers.ly;
in {
  config = mkIf cfg.enable {
    services.displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
      };
    };
  };
}
