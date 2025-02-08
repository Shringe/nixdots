{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.desktop.discord;
in
{
  config = lib.mkIf cfg.enable {
    # pkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
      # ripcord
      discord
      vencord
    ];
  };
}
