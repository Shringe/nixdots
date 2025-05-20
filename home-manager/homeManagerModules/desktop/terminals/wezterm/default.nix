{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.terminals.wezterm;
in
{
  programs.wezterm = lib.mkIf cfg.enable {
    enable = true;
    # unstable wezterm is currently broken at the time of making this
    # package = pkgs-stable.wezterm;

    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
