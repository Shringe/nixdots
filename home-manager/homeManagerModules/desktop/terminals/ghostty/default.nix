{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.terminals.ghostty;
in
{
  programs.ghostty = lib.mkIf cfg.enable {
    enable = true;

    settings = {
      window-padding-balance = true;
      window-decoration = "none";
      command = "direct:nu -e fastfetch";
    };
  };
}
