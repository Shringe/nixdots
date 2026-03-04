{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland;
  rgb = color: "rgb(${config.lib.stylix.colors.${color}})";
  # rgba = color: "rgba(${config.lib.stylix.colors.${color}}90)";

  # Make swayosd only open on active monitor
  swayosd = "${pkgs.swayosd_main_monitor}/bin/swayosd_main_monitor";

  # Allows minimizing certain apps like steam to tray instead of killing them
  killactive_wrapped = pkgs.writers.writeDash "killactive_wrapped" ''
    if [ "$(${pkgs.hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq -r ".class")" = "Steam" ]; then
        ${pkgs.xdotool}/bin/xdotool getactivewindow windowunmap
    else
        ${pkgs.hyprland}/bin/hyprctl dispatch killactive ""
    fi
  '';
in
{
  imports = [
    ./waybar
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprpolkit.nix
    ./hyprshot.nix
    ./plugins.nix
  ];

  options.homeManagerModules.desktop.windowManagers.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.enable;
    };

    monitors = {
      primary = mkOption {
        type = types.str;
        default = "eDP-1";
      };

      secondary = mkOption {
        type = types.str;
        default = cfg.monitors.primary;
      };
    };

    uid = mkOption {
      type = types.int;
      default = 1000;
      description = "Used to start walker faster via directly querying the unix socket";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprsunset
      xev
      wev
      slurp
      wlr-randr
    ];

    homeManagerModules.desktop.windowManagers.utils = {
      systemd = {
        enable = true;
        waylandTargets = [ "hyprland-session.target" ];
      };

      # wofi.enable = true;
      walker.enable = true;
      swaync.enable = true;
      cliphist.enable = true;
      swayosd.enable = true;
      dolphin.enable = true;
      wluma.enable = true;
      kclock.enable = true;
      polkit.enable = true;
      hyprlock.enable = true;
      wlogout.enable = true;
    };

    systemd.user.targets."hyprland-session" = {
      Unit.ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    wayland.windowManager.hyprland = {
      enable = true;

      systemd = {
        enable = true;
        variables = [ "--all" ];
      };

      settings = {
        "$mod" = "SUPER";
        "$d1" = cfg.monitors.primary;
        "$d2" = cfg.monitors.secondary;

        misc = {
          # enable_swallow = true;
          swallow_regex = "org.wezfurlong.wezterm";
          disable_autoreload = true;
          # animate_mouse_windowdragging = true;
          # animate_manual_resizes = true;
        };

        env = [
          "XCURSOR_SIZE,20"
          "GDK_BACKEND,wayland,x11,*"
          "QT_QPA_PLATFORM,wayland;xcb"
          "SDL_VIDEODRIVER,wayland,x11"
          "CLUTTER_BACKEND,wayland"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "__GL_GSYNC_ALLOWED,1"
          "__GL_VRR_ALLOWED,1"
        ];

        # Mouse
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        gesture = [
          "3, horizontal, workspace"
          "3, down, close"
          "3, up, fullscreen"
        ];

        # Layouts
        dwindle = {
          split_width_multiplier = 1.4;
        };

        # Repeating
        binde = [
          # Media
          "CTRL,XF86AudioRaiseVolume,exec,${swayosd} --input-volume raise"
          "CTRL,XF86AudioLowerVolume,exec,${swayosd} --input-volume lower"

          ", XF86AudioRaiseVolume, exec, ${swayosd} --output-volume raise"
          ", XF86AudioLowerVolume, exec, ${swayosd} --output-volume lower"

          "CTRL, XF86AudioRaiseVolume, exec, ${swayosd} --input-volume raise"
          "CTRL, XF86AudioLowerVolume, exec, ${swayosd} --input-volume lower"

          ", XF86MonBrightnessUp, exec, ${swayosd} --brightness raise"
          ", XF86MonBrightnessDown, exec, ${swayosd} --brightness lower"

          "SHIFT, XF86AudioRaiseVolume, exec, playerctl volume 0.1+"
          "SHIFT, XF86AudioLowerVolume, exec, playerctl volume 0.1-"
          "SHIFT, XF86AudioMute, exec, playerctl volume 0"

          # Resize
          "$mod, l, resizeactive, -100 0"
          "$mod, u, resizeactive, 100 0"
          "$mod, y, resizeactive, 0 -100"
          "$mod, semicolon, resizeactive, 0 100"
        ];

        bind = [
          # Hyprland
          "$mod CTRL, q, exit"
          ", Print, exec, hyprshot --output-folder $HOME/Pictures/screenshots/hyprland --mode region --notif-timeout --silent"
          "$mod, m, exec, hyprctl keyword general:layout master"
          "$mod, k, exec, hyprctl keyword general:layout dwindle"
          "$mod, v, exec, swaync-client -t -sw"

          # Media
          ", XF86AudioMute, exec, ${swayosd} --output-volume mute-toggle"
          "CTRL, XF86AudioMute, exec, ${swayosd} --input-volume mute-toggle"

          "SHIFT, XF86MonBrightnessUp, exec, playerctl shuffle Toggle"
          "SHIFT, XF86MonBrightnessDown, exec, playerctl loop Track"

          "CTRL, XF86MonBrightnessUp, exec, playerctl loop None"
          "CTRL, XF86MonBrightnessDown, exec, playerctl loop Playlist"

          ", XF86AudioPlay, exec, ${swayosd} --playerctl play-pause"
          ", XF86AudioNext, exec, ${swayosd} --playerctl next"
          ", XF86AudioPrev, exec, ${swayosd} --playerctl previous"

          # Applications
          "$mod, r, exec, zen-twilight"
          "$mod, Return, exec, wezterm"
          "$mod, w, exec, ${killactive_wrapped}"
          "$mod, Space, toggleFloating"
          "$mod, t, fullscreen"
          "$mod, c, exec, $HOME/.local/bin/clip-manager menu"

          # Wofi
          # "$mod, s, exec, wofi --show drun"
          # "$mod, p, exec, wofi-hyprswitch"
          # # "$mod, x, exec, wofi-power-menu"
          # "$mod, x, exec, wlogout"
          # "$mod, c, exec, wofi-emoji"
          # "$mod, d, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

          # Walker
          "$mod, s, exec, nc -U /run/user/${toString cfg.uid}/walker/walker.sock"
          # "$mod, p, exec, wofi-hyprswitch"
          # # "$mod, x, exec, wofi-power-menu"
          "$mod, x, exec, wleave"
          # "$mod, c, exec, wofi-emoji"
          # "$mod, d, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

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

          "$mod, code:19, workspace, 10"
          "$mod SHIFT, code:19, movetoworkspace, 10"
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
          repeat_rate = 30;
          repeat_delay = 500;

          follow_mouse = true;
          accel_profile = "flat";
          sensitivity = -0.675;
        };

        device = {
          name = "msft0001:01-04f3:3138-touchpad";
          sensitivity = 0.0;
        };

        cursor = {
          # no_break_fs_vrr = true;
        };

        render = {
          cm_auto_hdr = 1;
          cm_fs_passthrough = 1;
          direct_scanout = 1;
        };

        monitorv2 = [
          {
            output = "eDP-1";
            mode = "1920x1080@60";
            position = "0x0";
            scale = 1;
            bitdepth = 10;
            vrr = 0;
          }
          {
            output = "DP-1";
            mode = "2560x1440@165";
            position = "auto-left";
            scale = 1;
            bitdepth = 10;
            vrr = 1;
            # transform = 3;
          }
          {
            output = "HDMI-A-1";
            mode = "3440x1440@175";
            position = "0x0";
            scale = 1;
            bitdepth = 10;
            vrr = 1;

            # cm = "hdr";
            # supports_hdr = 1;
            # supports_wide_color = 1;
            # sdrbrightness = 1.0;
            # sdrsaturation = 1.0;
            # sdr_min_luminance = 0.005;
            # sdr_max_luminance = 250;
            # min_luminance = 0;
            # max_luminance = 1000;
            # max_avg_luminance = 250;
          }
        ];

        exec-once = [
          "[workspace 2 silent] zen-twilight"
          "[workspace 3 silent] wezterm"
          "[workspace 6 silent] steam"
          "[workspace 7 silent] wezterm start jellyfin-tui"
          "[workspace 8 silent] nheko"
          "[workspace 9 silent] thunderbird"
          "[workspace 10 silent] joplin-desktop"
        ];

        workspace = [
          "1, monitor:$d1, persistent:true"
          "2, monitor:$d1, persistent:true"
          "3, monitor:$d1, persistent:true"
          "4, monitor:$d1, persistent:true"
          "5, monitor:$d1, persistent:true"
          "6, monitor:$d1, persistent:true"

          "7, monitor:$d2, persistent:true"
          "8, monitor:$d2, persistent:true"
          "9, monitor:$d2, persistent:true"
          "10, monitor:$d2, persistent:true"
        ];

        windowrule = [
          "match:class ^(steam)$, workspace 6 silent"
        ];

        decoration = {
          rounding = 8;

          blur = {
            enabled = true;
            size = 8;
            passes = 3;
          };

          shadow = {
            enabled = true;
          };
        };

        "$bactive" = "${rgb "base07"} ${rgb "base07"} ${rgb "base0E"} 45deg";
        general = {
          border_size = 2;
          gaps_in = 2;
          gaps_out = 4;
          allow_tearing = true;

          "col.active_border" = mkForce "$bactive";
        };
      };

      # https://github.com/HyDE-Project/HyDE/blob/master/Configs/.config/hypr/animations/diablo-1.conf
      extraConfig =
        let
          layerBlur = name: ''
            layerrule = blur on, match:namespace ${name}
            # layerrule = ignorezero, match:namespace ${name}
            layerrule = ignore_alpha 0.5, match:namespace ${name}
          '';

          layerFade = name: ''
            layerrule = animation liner, match:namespace ${name}
          '';
        in
        ''
          ${layerBlur "swaync-control-center"}
          ${layerBlur "swaync-notification-window"}
          ${layerBlur "walker"}
          ${layerBlur "swayosd"}
          ${layerBlur "logout_dialog"}
          ${layerBlur "wleave"}

          ${layerFade "swayosd"}
          ${layerFade "hyprpaper"}
          ${layerFade "walker"}
          ${layerFade "logout_dialog"}
          ${layerFade "wleave"}
          ${layerFade "selection"}

          animations {
              enabled = 1
              bezier = default, 0.05, 0.9, 0.1, 1.05
              bezier = wind, 0.05, 0.9, 0.1, 1.05
              bezier = overshot, 0.13, 0.99, 0.29, 1.08
              bezier = liner, 1, 1, 1, 1
              bezier = bounce, 0.4, 0.9, 0.6, 1.0
              bezier = snappyReturn, 0.4, 0.9, 0.6, 1.0

              bezier = slideInFromRight, 0.5, 0.0, 0.5, 1.0
              animation = windows, 1, 5,  snappyReturn, slidevert
              animation = windowsIn, 1, 5, snappyReturn, slidevert right 
            
              animation = layersOut, 1, 5, bounce, slidevert right
              animation = layers, 1, 4, bounce, slidevert right

              # animation = layersOut, 1, 5, liner
              # animation = layers, 1, 4, liner

              animation = windowsOut, 1, 5, snappyReturn, slide 
              animation = windowsMove, 1, 6, bounce, slide
              animation = fadeIn, 1, 10, default
              animation = fadeOut, 1, 10, default
              animation = fadeSwitch, 1, 10, default
              animation = fadeShadow, 1, 10, default
              animation = fadeDim, 1, 10, default
              animation = fadeLayers, 1, 10, default
              animation = workspaces, 1, 7, overshot, slidevert
              animation = border, 1, 1, liner
              animation = borderangle, 1, 30, liner, loop
          } 
        '';
    };
  };
}
