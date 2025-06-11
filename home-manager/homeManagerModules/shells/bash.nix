{ lib, config, ... }:
{
  config.programs = {
    atuin = lib.mkIf config.homeManagerModules.shells.bash.atuin { 
      enableBashIntegration = true;
    };

    bash = lib.mkIf config.homeManagerModules.shells.bash.enable {
      enable = true;

      profileExtra = ''
        if [ -z "$DISPLAY" ]; then
          case "$XDG_VTNR" in
            1) exec sway --unsupported-gpu ;;
            2) exec sdwl ;;
            3) exec fish ;;
          esac
        fi
      '';
    };
  };
}
