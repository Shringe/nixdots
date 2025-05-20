{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.music;
in {
  imports = [
    ./termusic.nix
    ./supersonic.nix
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      playerctl
    ];

    services.playerctld = {
      enable = true;
    };
  };
}
