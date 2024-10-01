{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "media-control" (builtins.readFile ./scripts/media-control))
  ];
}
