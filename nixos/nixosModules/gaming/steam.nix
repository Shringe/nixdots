{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.gaming.steam;
in
{
  nixpkgs.config = lib.mkIf cfg.enable {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
  };

  programs = lib.mkIf cfg.enable {
    gamescope = {
      enable = true;

      # Asks for setuid right now?
      # capSysNice = true;

      # Doesn't seem to work either?
      # args = [
      #   "-W 3440"
      #   "-H 1440" 
      #   "-r 175"
      #   "-f"
      #   "--adaptive-sync"
      #   "--mangoapp"
      # ];
    };

    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      # gamescopeSession.enable = true;
    };
  };


  hardware = lib.mkIf cfg.enable {
    xone.enable = true;
    graphics.enable32Bit = true;
  };
}
