{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.terminals.alacritty;
in
{
  programs.alacritty = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      font.normal = {
        family = "JetbrainsMono";
        style = "Regular";
      };
      terminal.shell.program = "fish";
      window = {
        opacity = 0.88;
        padding = {
          # x = 4;
          # y = 1;
        };
      };
    };
  };
}
