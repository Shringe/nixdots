{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.niri.waybar;
  name = "niri";
  configFile = "${config.xdg.configFile."waybar/${name}/config".source}";
  styleFile = "${config.xdg.configFile."waybar/${name}/style.css".source}";

  toggleProcess = pkgs.writeShellApplication {
    name = "toggleProcess";
    runtimeInputs = with pkgs; [
      coreutils
      procps
    ];

    text = ''
      kill "$(pidof "$1")" 2>/dev/null || "$1"
    '';
  };

  notifyCopy = pkgs.writeShellApplication {
    name = "notifyCopy";
    runtimeInputs = with pkgs; [
      wl-clipboard
      libnotify
    ];

    text = ''
      if [ "$(notify-send --action "Copy" "$1: $2")" = "0" ]; then
        wl-copy "$2"
      fi
    '';
  };
in
{
  options.homeManagerModules.desktop.windowManagers.niri.waybar = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.niri.enable;
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.waybar.enable = false;

    systemd.user.services."${name}-waybar" = {
      Unit = {
        Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
        Documentation = "https://github.com/Alexays/Waybar/wiki";
        # PartOf = [
        #   "niri.service"
        # ];
        After = [ "niri.service" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
        X-Reload-Triggers = [
          configFile
          styleFile
        ];
      };

      Service = {
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        ExecStart = "${config.programs.waybar.package}/bin/waybar --config ${configFile} --style ${styleFile}";
        KillMode = "mixed";
        # Restart = "on-failure";
        Restart = "always";
        RestartSec = 1;
        Environment =
          with pkgs;
          mkForce "PATH=$PATH:${
            makeBinPath [
              # nordvpn
              # nordstatus
              coreutils
              procps
              swaynotificationcenter
              lxqt.pavucontrol-qt
              iwgtk
              curl
              libnotify
              notifyCopy
              toggleProcess
            ]
          }";
      };

      Install.WantedBy = [
        "niri.service"
      ];
    };

    xdg.configFile."waybar/${name}/config".source = ./config;
    xdg.configFile."waybar/${name}/style.css".source = ./style.css;
  };
}
