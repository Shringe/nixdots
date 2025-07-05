{ config, lib, ... }:
{
  config.home.shellAliases = lib.mkIf config.homeManagerModules.shells.aliases.enable {
    ls = "eza --group-directories-first --icons --group";
    pyclean = "find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete";
    
    nr = "nf run";
    ns = "nf shell";
    nd = "nf develop";

    rebuild = "doas nh os rebuild switch -R";
  };
}
