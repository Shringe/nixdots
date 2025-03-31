{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.discord;
in
{
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  config = mkIf cfg.enable {
    # pkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
      # ripcord
      # discord
      # vencord
    ];

    programs.nixcord = {
      enable = true;

      config = {
        frameless = true;
        transparent = true;
      };
    };
  };
}
