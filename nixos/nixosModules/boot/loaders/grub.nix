{ config, lib, ... }:
let
  cfg = config.nixosModules.boot.loaders.grub;
in
{
  config.boot.loader = lib.mkIf cfg.enable {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      efiInstallAsRemovable = true;
    };

    efi.canTouchEfiVariables = false;
  };
}
