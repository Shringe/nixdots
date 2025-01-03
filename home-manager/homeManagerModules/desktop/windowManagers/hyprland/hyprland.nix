{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland;
in
{
  home.packages = lib.mkIf cfg.enable [
    pkgs.wl-clipboard
  ];

  wayland.windowManager.hyprland = lib.mkIf cfg.enable {
    enable = true;

    systemd.variables = [ "--all" ];

    settings = {
      "$mod" = "SUPER";

      exec-once = [
        "waybar"
      ];

      bind = [
        # Hyprland
        "$mod CTRL, q, exit"

        # Applications
        "$mod, r, exec, firefox"
        "$mod, Return, exec, alacritty"
        "$mod, w, killactive"
        "$mod, s, exec, rofi -show drun"
        "$mod, Space, toggleFloating"
        "$mod, t, fullscreen"

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

        # Mouse
        # "$mod, mouse:272, movewindow"
        # "$mod, mouse:273, resizewindow"
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
        kb_layout = "us";

        repeat_rate = 40;
        repeat_delay = 300;

        follow_mouse = true;
        accel_profile = "flat";
        sensitivity = "-0.675";
      };

      monitor = [
        "HDMI-A-1, 3440x1440@175, 0x0, 1, bitdepth, 10, vrr, 1"
        "DP-1, 2560x1440@165, auto-left, 1, transform, 1, vrr, 1"
      ];

      workspace = [

      ]
      ++ ( 
        builtins.concatLists (builtins.genList (i:
            let
              monitor = "HDMI-A-1";
            in [
              "${toString i}, monitor:${monitor}"
            ]
          ) 
        7)
      )
      ++ ( 
        builtins.concatLists (builtins.genList (i:
            let
              monitor = "DP-1";
              ws = i + 7;
            in [
              "${toString ws}, monitor:${monitor}"
            ]
          ) 
        3)
      );


      decoration.blur = {
        enabled = true;
        # size = 3;
        # passes = 1;
      };

      general = {
        border_size = 1;
        gaps_in = 3;
        gaps_out = 2;
      };
    };
  };
}
