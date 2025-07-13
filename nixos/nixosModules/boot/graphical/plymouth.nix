{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.boot.graphical.plymouth;
in {
  options.nixosModules.boot.graphical.plymouth = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.boot.graphical.enable;
    };
  };

  config = mkIf cfg.enable {

  };
}
