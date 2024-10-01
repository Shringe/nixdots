{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # media-control
    (writeShellScriptBin "media-control" (builtins.readFile ./scripts/media-control))
    pulseaudio
    playerctl
    libnotify
  ];
}
