{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland;
in
{
  home.packages = with pkgs; lib.mkIf cfg.enable [
    hyprsunset
    xdg-desktop-portal-hyprland
  ];

  wayland.windowManager.hyprland = lib.mkIf cfg.enable {
    enable = true;

    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    settings = {
      "$mod" = "SUPER";
      "$d1" = "HDMI-A-1";
      "$d2" = "DP-1";

      exec-once = [
        "waybar"
        # "swaync"

        # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bind = [
        # Hyprland
        "$mod CTRL, q, exit"

        ",XF86AudioPlay,exec,media-control play_pause"
        ",XF86AudioNext,exec,media-control next"
        ",XF86AudioPrev,exec,media-control prev"
        ",XF86AudioRaiseVolume,exec,media-control volume_up"
        ",XF86AudioLowerVolume,exec,media-control volume_down"
        ",XF86AudioMute,exec,media-control volume_mute"
        "CTRL,XF86AudioRaiseVolume,exec,media-control mic_up"
        "CTRL,XF86AudioLowerVolume,exec,media-control mic_down"
        "CTRL,XF86AudioMute,exec,media-control mic_mute"

        # Applications
        "$mod, r, exec, firefox"
        "$mod, Return, exec, alacritty"
        "$mod, w, killactive"
        "$mod, Space, toggleFloating"
        "$mod, t, fullscreen"

        # Wofi
        "$mod, s, exec, wofi --show drun"

        "$mod, c, exec, wofi-emoji"
        "$mod, d, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

        # Window focus
        "$mod, n, movefocus, l"
        "$mod, o, movefocus, r"
        "$mod, i, movefocus, u"
        "$mod, e, movefocus, d"

        "$mod, Left, movefocus, l"
        "$mod, Right, movefocus, r"
        "$mod, Up, movefocus, u"
        "$mod, Down, movefocus, d"

        # Window movement
        "$mod CTRL, n, movewindow, l"
        "$mod CTRL, o, movewindow, r"
        "$mod CTRL, i, movewindow, u"
        "$mod CTRL, e, movewindow, d"

        "$mod CTRL, Left, movewindow, l"
        "$mod CTRL, Right, movewindow, r"
        "$mod CTRL, Up, movewindow, u"
        "$mod CTRL, Down, movewindow, d"

        # Window size
        "$mod ALT, n, resizeactive, 10 0"
        "$mod ALT, o, resizeactive, -10 0"
        "$mod ALT, i, resizeactive, 0 -10"
        "$mod ALT, e, resizeactive, 0 10"

        "$mod ALT, Left, resizeactive, 10 0"
        "$mod ALT, Right, resizeactive, -10 0"
        "$mod ALT, Up, resizeactive, 0 10"
        "$mod ALT, Down, resizeactive, 0 -10"

      ]
      ++ (
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
        9)
      );

      input = {
        repeat_rate = 40;
        repeat_delay = 300;

        follow_mouse = true;
        accel_profile = "flat";
        sensitivity = "-0.675";
      };

      cursor = {
        no_break_fs_vrr = true;
      };

      monitor = [
        "$d1, 3440x1440@175, 0x0, 1, bitdepth, 10, vrr, 2"
        "$d2, 2560x1440@165, auto-left, 1, bitdepth, 10, transform, 1, vrr, 1"
      ];

      workspace = [
        "1, monitor:$d1"
        "2, monitor:$d1"
        "3, monitor:$d1"
        "4, monitor:$d1"
        "5, monitor:$d1"
        "6, monitor:$d1"

        "7, monitor:$d2"
        "8, monitor:$d2"
        "9, monitor:$d2"
      ];

      windowrulev2 = [
        "workspace 7, class:discord"
        "workspace 9, class:steam"
      ];

      decoration = {
        rounding = 8;

        blur = {
          enabled = true;
          size = 12;
          passes = 1;
        };
      };

      general = {
        border_size = 2;
        gaps_in = 2;
        gaps_out = 3;

        allow_tearing = true;
      };

      animation = [
        "workspaces, 1, 5, default"
        "windows, 1, 5, default"
        "fade, 1, 5, default"
        "layers, 1, 5, default"
      ];
    };
  };
}
