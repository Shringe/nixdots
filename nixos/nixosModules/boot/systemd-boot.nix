{ config, lib, ... }:
let
  cfg = config.nixosModules.boot.systemd-boot;
in
{
  boot.loader = lib.mkIf cfg.enable {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
