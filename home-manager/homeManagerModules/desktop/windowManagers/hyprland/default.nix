{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland;
in
{
  imports = [
    ./hypridle.nix
    ./hyprpaper.nix
    ./waybar.nix
  ];

  options.homeManagerModules.desktop.windowManagers.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprsunset
      hyprshot
    ];

    homeManagerModules.desktop.windowManagers.utils = {
      wofi.enable = true;
      swaync.enable = true;
      cliphist.enable = true;
      swayosd.enable = true;
      dolphin.enable = true;
      polkit.enable = true;
      systemd.enable = true;
      wlogout.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;

      systemd = {
        enable = true;
        variables = [ "--all" ];
      };

      settings = {
        "$mod" = "SUPER";
        "$d1" = "HDMI-A-1";
        "$d2" = "DP-1";
        experimental.xx_color_management_v4 = "true";

        # Mouse
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        # Repeating
        bindr = [
          ",XF86AudioRaiseVolume,exec,media-control volume_up"
          ",XF86AudioLowerVolume,exec,media-control volume_down"

          "CTRL,XF86AudioRaiseVolume,exec,media-control mic_up"
          "CTRL,XF86AudioLowerVolume,exec,media-control mic_down"
        ];

        bind = [
          # Hyprland
          "$mod CTRL, q, exit"
          ", Print, exec, hyprshot --mode region"

          ",XF86AudioPlay,exec,media-control play_pause"
          ",XF86AudioNext,exec,media-control next"
          ",XF86AudioPrev,exec,media-control prev"
          ",XF86AudioMute,exec,media-control volume_mute"
          "CTRL,XF86AudioMute,exec,media-control mic_mute"

          # Applications
          "$mod, r, exec, zen-twilight"
          "$mod, Return, exec, wezterm"
          "$mod, w, killactive"
          "$mod, Space, toggleFloating"
          "$mod, t, fullscreen"

          # Wofi
          "$mod, s, exec, wofi --show drun"
          "$mod, x, exec, wlogout"
          "$mod, c, exec, wofi-emoji"
          "$mod, d, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

          # Window focus
          "$mod, n, movefocus, l"
          "$mod, o, movefocus, r"
          "$mod, i, movefocus, u"
          "$mod, e, movefocus, d"

          # Window movement
          "$mod CTRL, n, movewindow, l"
          "$mod CTRL, o, movewindow, r"
          "$mod CTRL, i, movewindow, u"
          "$mod CTRL, e, movewindow, d"

          # Window size
          "$mod SHIFT, n, resizeactive, 40 0"
          "$mod SHIFT, o, resizeactive, -40 0"
          "$mod SHIFT, i, resizeactive, 0 -40"
          "$mod SHIFT, e, resizeactive, 0 40"
        ]
        ++ (
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
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

        render = {
          # explicit_sync = 0;
          cm_auto_hdr = 1;
          cm_fs_passthrough = 2;
        };

        monitor = [
          "$d2, 2560x1440@165, auto-left, 1, bitdepth, 10, vrr, 2"
        ];

        monitorv2 = [
          {
            output = "$d1";
            mode = "3440x1440@175";
            position = "0x0";
            scale = 1;
            bitdepth = 10;
            vrr = 2;

            # cm = "hdr";
            supports_hdr = 1;
            supports_wide_color = 1;
            # sdrbrightness = 1.0;
            # sdrsaturation = 1.0;
            # sdr_min_luminance = 0.005;
            # sdr_max_luminance = 250;
            # min_luminance = 0;
            # max_luminance = 1000;
            # max_avg_luminance = 250;
          }
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
          # "workspace 7, class:discord"
          # "workspace 9, class:steam"
        ];

        decoration = {
          rounding = 8;

          blur = {
            enabled = true;
            size = 5;
            passes = 3;
          };
        };

        general = {
          border_size = 2;
          gaps_in = 2;
          gaps_out = 5;

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
  };
}
