{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.gaming.emulators.wiiu.cemu;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cemu
    ];
  };
}
