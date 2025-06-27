{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.homeManagerModules.shells.fish;
in {
  config = mkIf cfg.enable {
    programs = {
      atuin.enableFishIntegration = true;
      yazi.enableFishIntegration = true;

      fish = {
        enable = true;
        interactiveShellInit = ''
          fish_vi_key_bindings
          set fish_greeting
        '';

        plugins = [
          { name = "tide" ; src = pkgs.fishPlugins.tide.src; }  
          { name = "done" ; src = pkgs.fishPlugins.done.src; }
          { name = "colored-man-pages" ; src = pkgs.fishPlugins.colored-man-pages.src; }
          { name = "pisces" ; src = pkgs.fishPlugins.pisces.src; }
          { name = "fzf-fish" ; src = pkgs.fishPlugins.fzf-fish.src; }
          { name = "humantime-fish" ; src = pkgs.fishPlugins.humantime-fish.src; }
        ];
      };
    };
  };  
}
