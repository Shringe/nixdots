{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.scripts;
in {
  options.homeManagerModules.desktop.windowManagers.utils.scripts = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.enable;
    };

    toggleDaemon = mkOption {
      type = types.package;
      default = pkgs.writeShellApplication {
        name = "toggleDaemon";
        runtimeInputs = [
          pkgs.procps
        ];

        text = ''
          set +o errexit
          pid=$(pidof "$1")
          if [ -n "$pid" ]; then
            kill "$pid"
          else
            "$@" &
          fi
        '';
      };
    };

    toggleGammastep = mkOption {
      type = types.package;
      default = pkgs.writeShellApplication {
        name = "toggleGammastep";
        runtimeInputs = [
          pkgs.gammastep
          cfg.toggleDaemon
        ];

        text = ''
          toggleDaemon gammastep -O 3200
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with cfg; [
      toggleGammastep
    ];
  };
}

