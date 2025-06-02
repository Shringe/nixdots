{ lib, config, ... }:
{
  config.programs = {
    atuin = lib.mkIf config.homeManagerModules.shells.bash.atuin { 
      enableBashIntegration = true;
    };

    bash = lib.mkIf config.homeManagerModules.shells.bash.enable {
      enable = true;

      initExtra = ''
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
          exec sway --unsupported-gpu
        fi
      '';
    };
  };
}
