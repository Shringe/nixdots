{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.backups.btrbk;
in {
  options.nixosModules.backups.btrbk = {
    enable = mkEnableOption "Btrfs backup tool";
  };

  config = mkIf cfg.enable {
    services.btrbk = {
      # Option not needed
      # enable = true;

      # Instances moved to respective nixos/nixosModules/drives/
      instances = {

      };
    };
  };
}
