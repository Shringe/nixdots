{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.boot.loader.grub;
in {
  options.nixosModules.boot.loader.grub = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  
  config = mkIf cfg.enable {
    boot.loader = {
      efi.canTouchEfiVariables = false;

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        efiInstallAsRemovable = true;
      };
    };
  };
}
