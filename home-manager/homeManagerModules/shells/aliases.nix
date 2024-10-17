{ config, lib, ... }:
{
  options = {
    shells.aliases = {
      enable = lib.mkEnableOption "Pass shells.aliases.raw to home.shellAliases";
    };
  };
  config.home.shellAliases = lib.mkIf config.shells.aliases.enable {
    ls = "eza --group-directories-first --icons --group";
    pyclean = "find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete";
  };
}
