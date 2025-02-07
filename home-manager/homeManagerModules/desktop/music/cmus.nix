{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.music.cmus;
in
{
  config.programs.cmus = lib.mkIf cfg.enable {
    enable = true;
  };
}
