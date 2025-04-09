{ config, lib, pkgs, unstablePkgs, ... }:
with lib;
let
  cfg = config.nixosModules.players.mpv;
in {
  options.nixosModules.players.mpv = {
    enable = mkEnableOption "MPV media player";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      unstablePkgs.mpv
    ];
  };
}
