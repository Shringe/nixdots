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
    pkgs.lutris
    pkgs.vulkan-tools
    pkgs.wine
    pkgs.wine64

    # pkgs.protonhax
    pkgs.discord
    pkgs.pulsemixer
  ];

  nixpkgs.config = lib.mkIf cfg.enable { 
    packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
      };
    };
  };

  # Temporary: for KDE Plasma's HDR support. Will be removed after universal HDR implementations
  services.desktopManager.plasma6.enable = lib.mkIf cfg.enable true;
}
