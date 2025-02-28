{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.gaming.emulators.switch.torzu;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      torzu
      parsec-bin
    ];
  };
}
