{ pkgs, ... }:
{
  programs = {
    atuin.enableFishIntegration = true;
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # disable greeting

        # Prefix <nix-shell> to prompt if in nix-shell
        set -l nix_shell_info (
          if test -n "$IN_NIX_SHELL"
            echo -n "<nix-shell> "
          end
        )
      '';

      plugins = [
        # { name = "tide" ; src = pkgs.fishPlugins.tide.src; }  
        # { name = "pure" ; src = pkgs.fishPlugins.pure.src; }
        { name = "done" ; src = pkgs.fishPlugins.done.src; }
        { name = "colored-man-pages" ; src = pkgs.fishPlugins.colored-man-pages.src; }
        { name = "pisces" ; src = pkgs.fishPlugins.pisces.src; }
        { name = "fzf-fish" ; src = pkgs.fishPlugins.fzf-fish.src; }
        { name = "humantime-fish" ; src = pkgs.fishPlugins.humantime-fish.src; }
      ];
    };
  };
}
