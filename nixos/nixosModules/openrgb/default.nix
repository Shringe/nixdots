{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.openrgb;
in
{
  services = lib.mkIf cfg.enable {
    hardware.openrgb = {
      enable = true;
    };

    udev.packages = [ pkgs.openrgb ];
  };

  environment.systemPackages = lib.mkIf cfg.enable [ pkgs.openrgb-plugin-effects ];

  hardware.i2c.enable = lib.mkIf cfg.enable true;
  boot.kernelModules = lib.mkIf cfg.enable [ "i2c-dev" ];
}
