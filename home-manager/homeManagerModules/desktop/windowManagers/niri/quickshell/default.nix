{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.niri.quickshell;
  targets = [ "niri.service" ];
in
{
  options.homeManagerModules.desktop.windowManagers.niri.quickshell = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.niri.enable;
      # default = false;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.quickshell = {
      Install.WantedBy = targets;
      Unit = {
        After = targets;
        PartOf = targets;
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${
          inputs.qml-niri.packages.${pkgs.stdenv.hostPlatform.system}.quickshell
        }/bin/quickshell";
        Restart = "on-failure";
      };
    };

    xdg.configFile."quickshell/inner".source =
      config.lib.file.mkOutOfStoreSymlink "/nixdots/home-manager/homeManagerModules/desktop/windowManagers/niri/quickshell/config";

    xdg.configFile."quickshell/shell.qml".text = ''
      import Quickshell
      import "./inner"

      ShellRoot {
          Main {}
      }
    '';

    xdg.configFile."quickshell/Config.qml".text = ''
      pragma Singleton
      import Quickshell

      Singleton {
          readonly property string background: "#1C1F22"
          readonly property string accent: "#106DAA"
      }
    '';
  };
}
