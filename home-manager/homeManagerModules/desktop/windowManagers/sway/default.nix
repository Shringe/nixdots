{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.sway;
  mod = config.wayland.windowManager.sway.config.modifier;
in {
  imports = [
    ./waybar.nix
    ./swaylogout.nix
  ];

  options.homeManagerModules.desktop.windowManagers.sway = {
    enable = lib.mkEnableOption "sway configuration";

    proportions = {
      gaps = {
        inner = mkOption {
          type = types.int;
          default = 3;
        };

        outer = mkOption {
          type = types.int;
          default = 3;
        };
      };

      border = mkOption {
        type = types.int;
        default = 2;
      };
    };
  };

  config = mkIf cfg.enable {
    homeManagerModules.desktop = {
      terminals.alacritty.enable = mkDefault true;

      windowManagers.sway = {
        waybar.enable = mkDefault true;
        # swaylogout.enable = mkDefault true;
      };
    };

    home.packages = with pkgs; [
      plasma5Packages.kdeconnect-kde
      wofi-power-menu
    ];

    home.sessionVariables = {
      WLR_RENDERER = "vulkan";
    };

    wayland.windowManager.sway = {
      enable = true;

      swaynag.enable = true;
      config = rec {
        modifier = "Mod4";
        terminal = "alacritty"; 
        menu = "wofi --show drun";

        left = "n";
        down = "e";
        up = "i";
        right = "o";

        # # As to not override all default keybindings
        # keybindings = with config.wayland.windowManager.sway.config; {
        #   "bindsym ${mod}+Return" = "exec ${terminal}";
        #   "bindsym ${mod}+Shift+q" = "kill";
        #   "${mod}+d" = "exec ${menu}";
        #   "floating_modifier ${mod}" = "normal";
        #   "bindsym ${mod}+Shift+c" = "reload";
        # };

        bars = [];

        keybindings = with config.wayland.windowManager.sway.config; {
          # Window Manager
          # "floating_modifier ${mod}" = "normal";
          "${mod}+w" = "kill";
          "${mod}+Shift+Alt+Control+c" = "reload";
          "${mod}+Shift+q" = "d the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";

          # Media
          "Print" = "exec grim";
          "--locked XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "--locked XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "--locked XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "--locked XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "--locked XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "--locked XF86MonBrightnessUp" = "exec brightnessctl set 5%+";


          # Applications
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+s" = "exec ${menu}";
          "${mod}+r" = "exec firefox";
          "${mod}+x" = "exec wofi-power-menu --config ~/.config/wofi-power-menu/sway.toml";
          "${mod}+c" = "exec wofi-emoji";
          "${mod}+d" = "exec cliphist list | wofi --dmenu | cliphist decode | wl-copy";

          # Focus movement
          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          # Move window
          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${right}" = "move right";
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          # Workspaces
          # Switch to workspace
          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";

          # Move container to workspace
          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";

          # Layout controls
          "${mod}+h" = "splith";
          "${mod}+comma" = "splitv";
          "${mod}+l" = "layout stacking";
          "${mod}+u" = "layout tabbed";
          "${mod}+y" = "layout toggle split";
          "${mod}+t" = "fullscreen";
          "${mod}+Shift+space" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";
          "${mod}+a" = "focus parent";

          # Scratchpad
          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";

          # Resize mode
          "${mod}+f" = "mode resize";
        };

        startup = [
          { command = "waybar"; }
          { command = "kdeconnect-indicator"; }
        ];

        gaps = {
          # bottom = cfg.proportions.gaps;
          # top = cfg.proportions.gaps;
          # left = cfg.proportions.gaps;
          # right = cfg.proportions.gaps;

          inner = cfg.proportions.gaps.inner;
          outer = cfg.proportions.gaps.outer; 
        };

        window = {
          titlebar = false;
          border = cfg.proportions.border;
        };

        floating = {
          titlebar = false;
          criteria = [
            { window_role = "pop-up"; }
            { window_role = "About"; }
            { title = "MainPicker"; }
          ];
        };

        input = {
          "*" = {
            pointer_accel = "-0.675";
            accel_profile = "flat";
          };
        };

        output = {
          HDMI-A-1 = {
            mode = "3440x1440@175Hz";
            allow_tearing = "yes";
            adaptive_sync = "yes";

            render_bit_depth = "10";
          };
        };
      };

      extraOptions = [
        "--unsupported-gpu"
      ];
    };
  };
}
