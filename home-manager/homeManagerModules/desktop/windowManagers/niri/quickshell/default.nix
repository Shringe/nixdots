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

    package = mkOption {
      type = types.package;
      default = inputs.qml-niri.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
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
        ExecStart = "${cfg.package}/bin/quickshell";
        Restart = "on-failure";
        Environment =
          with pkgs;
          "PATH=$PATH:${
            makeBinPath [
              gammastep
              cava
              mpvpaper
              swww
            ]
          }";
      };
    };

    services.swww = {
      enable = true;
    };

    systemd.user.services.swww.Install.WantedBy = [ "niri.service" ];

    home.packages = [
      cfg.package
    ];

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

    xdg.configFile."quickshell/Config.qml".text = ''
      pragma Singleton
      import QtQuick
      import Quickshell

      Singleton {
          readonly property QtObject colors: QtObject {
              readonly property color base00: "${config.lib.stylix.colors.withHashtag.base00}"
              readonly property color base01: "${config.lib.stylix.colors.withHashtag.base01}"
              readonly property color base02: "${config.lib.stylix.colors.withHashtag.base02}"
              readonly property color base03: "${config.lib.stylix.colors.withHashtag.base03}"
              readonly property color base04: "${config.lib.stylix.colors.withHashtag.base04}"
              readonly property color base05: "${config.lib.stylix.colors.withHashtag.base05}"
              readonly property color base06: "${config.lib.stylix.colors.withHashtag.base06}"
              readonly property color base07: "${config.lib.stylix.colors.withHashtag.base07}"
              readonly property color base08: "${config.lib.stylix.colors.withHashtag.base08}"
              readonly property color base09: "${config.lib.stylix.colors.withHashtag.base09}"
              readonly property color base0A: "${config.lib.stylix.colors.withHashtag.base0A}"
              readonly property color base0B: "${config.lib.stylix.colors.withHashtag.base0B}"
              readonly property color base0C: "${config.lib.stylix.colors.withHashtag.base0C}"
              readonly property color base0D: "${config.lib.stylix.colors.withHashtag.base0D}"
              readonly property color base0E: "${config.lib.stylix.colors.withHashtag.base0E}"
              readonly property color base0F: "${config.lib.stylix.colors.withHashtag.base0F}"
          }

          readonly property QtObject fonts: QtObject {
              readonly property string family: "${config.stylix.fonts.monospace.name}"
              readonly property int size: ${toString config.stylix.fonts.sizes.terminal}
          }

          readonly property QtObject borders: QtObject {
              readonly property int size: 2
              readonly property int radius: 6
          }

          readonly property int barHeight: 24

          readonly property QtObject hardware: QtObject {
              readonly property bool isLaptop: ${boolToString config.homeManagerModules.info.isLaptop}
          }

          readonly property QtObject dependencies: QtObject {
              readonly property string swww: "${pkgs.swww}/bin/swww"
          }
      }
    '';
  };
}
