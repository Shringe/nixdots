{ config, lib, unstablePkgs, ... }:
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
    gamescope.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with unstablePkgs; [
        proton-ge-bin
      ];
      # gamescopeSession.enable = true;
    };
  };


  hardware = lib.mkIf cfg.enable {
    xone.enable = true;
    graphics.enable32Bit = true;
  };

  environment.systemPackages = lib.mkIf cfg.enable [
    # pkgs.proton-ge-bin
  ];
}
