{ config, lib, ... }:
let
  cfg = config.nixosModules.boot.loaders.systemd-boot;
in
{
  boot.loader = lib.mkIf cfg.enable {
    timeout = 0;
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
