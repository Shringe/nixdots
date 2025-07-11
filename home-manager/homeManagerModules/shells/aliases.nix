{ config, lib, pkgs, ... }:
{
  config.home.shellAliases = lib.mkIf config.homeManagerModules.shells.aliases.enable {
    pyclean = "find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete";
    
    nr = "nf run";
    ns = "nf shell";
    nd = "nf develop";

    rcp = "rcp --progress";
    grep = "ripgrep";
    df = "duf";
    du = "dust";
    find = "fd";
    cat = "bat";
  };
}
