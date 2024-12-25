{ lib, config, pkgs, ... }:
let
  cfg = config.homeManagerModules.shells.tmux;
in
{
  programs.tmux = lib.mkIf cfg.enable {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
  };
}
