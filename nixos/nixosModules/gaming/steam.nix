{ config, lib, ... }:
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

  programs.steam = lib.mkIf cfg.enable {
    enable = true;
  };
}
