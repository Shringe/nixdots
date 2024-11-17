{ lib, pkgs, config, ... }:
{
  config.programs = {
    # atuin = lib.mkIf config.shells.fish.atuin { 
    #   enableFishIntegration = true;
    # };
    fish = lib.mkIf config.homeManagerModules.shells.fish.enable {
      enable = true;
      interactiveShellInit = ''
        fish_vi_key_bindings
        set fish_greeting # disable greeting
      '';

      plugins = [
        { name = "transient-fish" ; src = pkgs.fishPlugins.transient-fish.src; }  
        # { name = "bobthefish" ; src = pkgs.fishPlugins.bobthefish.src; }  
        # { name = "hydro" ; src = pkgs.fishPlugins.hydro.src; }  
        # { name = "tide" ; src = pkgs.fishPlugins.tide.src; }  
        # { name = "pure" ; src = pkgs.fishPlugins.pure.src; }
        # { name = "done" ; src = pkgs.fishPlugins.done.src; }
        { name = "colored-man-pages" ; src = pkgs.fishPlugins.colored-man-pages.src; }
        { name = "pisces" ; src = pkgs.fishPlugins.pisces.src; }
        { name = "fzf-fish" ; src = pkgs.fishPlugins.fzf-fish.src; }
        { name = "humantime-fish" ; src = pkgs.fishPlugins.humantime-fish.src; }
      ];
    };
  };  
}
