{ pkgs, config, lib, ... }:
{
  home.packages = with pkgs; lib.mkIf config.homeManagerModules.scripts.enable [
    (writeShellApplication {
      name = "media-control";
      runtimeInputs = [ dunst pulseaudio playerctl libnotify ];
      text = builtins.readFile ./media-control.sh;
    })
  ];
}
