{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.niri.dms;
  target = "niri.service";
in
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  options.homeManagerModules.desktop.windowManagers.niri.dms = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.niri.enable;
      # default = false;
    };

    laptopMode = mkOption {
      type = types.bool;
      default = false;
      description = "Enable things like battery indicators and power saving features";
    };
  };

  config = mkIf cfg.enable {
    programs.dank-material-shell = {
      enable = true;

      systemd = {
        enable = true;
        target = target;
      };

      # https://raw.githubusercontent.com/AvengeMedia/DankMaterialShell/refs/heads/master/quickshell/Common/settings/SessionSpec.js
      session = {
        wallpaperPath = config.homeManagerModules.theming.wallpapers.primary;
        perMonitorWallpaper = true;
        monitorWallpapers = {
          "HDMI-A-1" = "/nixdots/assets/wallpapers/grassmastersword_3440x1440.png";
          "DP-1" = "/nixdots/assets/wallpapers/2b_nier_automata_2560x1440.png";
        };
      };

      # https://raw.githubusercontent.com/AvengeMedia/DankMaterialShell/refs/heads/master/quickshell/Common/settings/SettingsSpec.js
      settings = {
        barConfigs = [
          {
            id = "HDMI-A-1";
            enabled = true;
            screenPreferences = [ "HDMI-A-1" ];

            ## Widgets
            leftWidgets = [
              "launcherButton"
              "systemTray"
              "focusedWindow"
            ];

            centerWidgets = [
              "workspaceSwitcher"
            ];

            rightWidgets = [
              "music"
              "volume"
              "easyEffects"
              "battery"
              "memUsage"
              "cpuUsage"
              "notificationButton"
              "clock"
            ];

            ## Layout
            position = 0; # 0=top, 1=bottom, 2=left, 3=right
            spacing = 0;
            bottomGap = 0;
            innerPadding = 0; # Sets the bar size, strangely
            squareCorners = true;
            maximizeDetection = false; # Don't remove gaps if the window is maxximized

            ## Behavior
            scrollXBehavior = "none";
            scrollYBehavior = "none";
          }
        ];
      };

      # NixOS module only?
      # enableVPN = false;
      # enableSystemMonitoring = false;
      # enableDynamicTheming = false;
      # enableAudioWaveLength = false;
      # enableCalendarEvents = false;
      # enableClipboardPaste = true;
    };
  };
}
