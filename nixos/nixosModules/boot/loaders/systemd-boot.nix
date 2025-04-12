{ config, lib, ... }:
let
  cfg = config.nixosModules.boot.loaders.systemd-boot;
in
{
  boot.loader = lib.mkIf cfg.enable {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
