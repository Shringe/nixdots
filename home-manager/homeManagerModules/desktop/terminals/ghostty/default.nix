{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.terminals.ghostty;
in
{
  programs.ghostty = lib.mkIf cfg.enable {
    enable = true;

    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
