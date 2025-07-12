{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.boot.loader.systemd-boot;
in {
  options.nixosModules.boot.loader.systemd-boot = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.boot.loader.enable;
    };
  };
  
  config = mkIf cfg.enable {
    boot.loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
      };
    };
  };
}
