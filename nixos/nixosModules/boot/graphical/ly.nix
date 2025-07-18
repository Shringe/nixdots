{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.boot.graphical.ly;
in {
  options.nixosModules.boot.graphical.ly = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
      };
    };
  };
}
