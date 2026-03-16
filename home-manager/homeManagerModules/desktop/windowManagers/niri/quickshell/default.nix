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
      //@ pragma UseQApplication
      //@ pragma Env QS_NO_RELOAD_POPUP=1
      //@ pragma Env QSG_RENDER_LOOP=threaded
      //@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

      import "inner"

      Main {}
    '';

    xdg.configFile."quickshell/Config.qml".text = with config.lib.stylix.colors.withHashtag; ''
      pragma Singleton
      import QtQuick
      import Quickshell

      Singleton {
          readonly property QtObject colors: QtObject {
              readonly property string base00: "${base00}"
              readonly property string base01: "${base01}"
              readonly property string base02: "${base02}"
              readonly property string base03: "${base03}"
              readonly property string base04: "${base04}"
              readonly property string base05: "${base05}"
              readonly property string base06: "${base06}"
              readonly property string base07: "${base07}"
              readonly property string base08: "${base08}"
              readonly property string base09: "${base09}"
              readonly property string base0A: "${base0A}"
              readonly property string base0B: "${base0B}"
              readonly property string base0C: "${base0C}"
              readonly property string base0D: "${base0D}"
              readonly property string base0E: "${base0E}"
              readonly property string base0F: "${base0F}"
          }

          readonly property QtObject fonts: QtObject {
              readonly property string family: "JetBrainsMono Nerd Font"
              readonly property int size: 14
          }
      }
    '';
  };
}
