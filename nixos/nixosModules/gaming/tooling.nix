{ config, lib, pkgs, pkgs-stable, ... }:
let
  cfg = config.nixosModules.gaming.tooling;
in
{
  environment.systemPackages = lib.mkIf cfg.enable [
    pkgs.steam-run
    pkgs.gamemode
    pkgs.mangohud
    pkgs.gamescope
    # pkgs.protonhax
  ];

  # Temporary: for KDE Plasma's HDR support. Will be removed after universal HDR implementations
  services.desktopManager.plasma6.enable = lib.mkIf cfg.enable true;
}
