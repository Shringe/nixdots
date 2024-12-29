{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.development.pi.tooling;
in
{
  environment.systemPackages = lib.mkIf cfg.enable [
    pkgs.rpi-imager
  ];
}
