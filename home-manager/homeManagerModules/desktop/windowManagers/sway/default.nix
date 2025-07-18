{ config, lib, unstablePkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.sway;
  mpvpaper = config.homeManagerModules.desktop.windowManagers.utils.mpvpaper;
  mod = config.wayland.windowManager.sway.config.modifier;

  displ1 = "HDMI-A-1";
  displ2 = "DP-1";
in {
  imports = [
    ./swaylogout.nix
    ./swayidle.nix
  ];

  options.homeManagerModules.desktop.windowManagers.sway = {
    enable = lib.mkEnableOption "sway configuration";
    enableSwayFx = mkOption {
      type = types.bool;
      default = true;
    };

    proportions = {
      gaps = {
        inner = mkOption {
          type = types.int;
          default = 3;
        };

        outer = mkOption {
          type = types.int;
          default = 1;
        };
      };

      border = mkOption {
        type = types.int;
        default = 2;
      };
    };
  };

  config = mkIf cfg.enable {
    stylix.opacity = mkIf cfg.enableSwayFx {
      desktop = 0.88;
    };

    homeManagerModules.desktop = {
      terminals.alacritty.enable = mkDefault true;
      terminals.wezterm.enable = mkDefault true;

      windowManagers = {
        sway = {
          swayidle.enable = mkDefault true;
        };

        utils = {
          waybar = {
            enable = mkDefault true;
            transparent.enable = mkIf cfg.enableSwayFx true;
            colorful.enable = mkIf cfg.enableSwayFx false;
          };

          # swaylogout.enable = mkDefault true;
          swaync.enable = mkDefault true;
          mpvpaper.enable = mkDefault cfg.enableSwayFx;
          swaylock.enable = mkDefault true;
          wofi.enable = mkDefault true;
          cliphist.enable = mkDefault true;
        };
      };
    };

    home.packages = with unstablePkgs; [
      # plasma5Packages.kdeconnect-kde
      # wofi-power-menu
      # playerctl
    ];

    home.sessionVariables = {
      WLR_RENDERER = "vulkan";
    };

    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;

      # SwayFX config
      package = mkIf cfg.enableSwayFx unstablePkgs.swayfx;
      checkConfig = mkIf cfg.enableSwayFx false;
      extraConfig = mkIf cfg.enableSwayFx ''
        corner_radius 12
        blur enable
        blur_passes 2
        shadows enable

        set $opacity ${toString config.stylix.opacity.desktop}
        for_window [app_id="wofi"] floating enable, sticky enable
        for_window [floating] opacity $opacity
        for_window [app_id="com.github.iwalton3.jellyfin-media-player"] inhibit_idle visible

        layer_effects "waybar" {
          blur enable;
          corner_radius 8;
          blur_ignore_transparent enable;
          shadows disable;
          corner_radius 0;
        }

        layer_effects "swaync-control-center" {
          blur enable;
          blur_ignore_transparent enable;
          shadows disable;
          corner_radius 0;
        }
      '';

      swaynag.enable = true;
      config = rec {
        modifier = "Mod4";
        terminal = "wezterm"; 
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

        startup = [
          { command = "kdeconnect-indicator"; }

          (mkIf mpvpaper.primary.enable {
            always = true;
            command = "systemctl --user restart mpvpaper_primary";
          })

          (mkIf mpvpaper.secondary.enable {
            always = true;
            command = "systemctl --user restart mpvpaper_secondary";
          })

          (mkIf mpvpaper.laptop.enable {
            always = true;
            command = "systemctl --user restart mpvpaper_laptop";
          })
        ];

        workspaceOutputAssign = [
          { output = displ1; workspace = "1"; }
          { output = displ1; workspace = "2"; }
          { output = displ1; workspace = "3"; }
          { output = displ1; workspace = "4"; }
          { output = displ1; workspace = "5"; }
          { output = displ1; workspace = "6"; }
          { output = displ1; workspace = "7"; }
          { output = displ1; workspace = "8"; }
          { output = displ1; workspace = "9"; }
          { output = displ1; workspace = "10"; }

          { output = displ2; workspace = "11"; }
          { output = displ2; workspace = "12"; }
          { output = displ2; workspace = "13"; }
          { output = displ2; workspace = "14"; }
          { output = displ2; workspace = "15"; }
          { output = displ2; workspace = "16"; }
          { output = displ2; workspace = "17"; }
          { output = displ2; workspace = "18"; }
          { output = displ2; workspace = "19"; }
          { output = displ2; workspace = "20"; }
        ];

        bars = [];

        keybindings = with config.wayland.windowManager.sway.config; {
          # Window Manager
          # "floating_modifier ${mod}" = "normal";
          "${mod}+w" = "kill";
          "${mod}+Shift+q" = "d the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";

          # Media
          "XF86AudioPlay" = "exec playerctl play-pause";

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

          # Extra workspaces (11–20)
          # Switch to workspace
          "${mod}+Control+1" = "workspace number 11";
          "${mod}+Control+2" = "workspace number 12";
          "${mod}+Control+3" = "workspace number 13";
          "${mod}+Control+4" = "workspace number 14";
          "${mod}+Control+5" = "workspace number 15";
          "${mod}+Control+6" = "workspace number 16";
          "${mod}+Control+7" = "workspace number 17";
          "${mod}+Control+8" = "workspace number 18";
          "${mod}+Control+9" = "workspace number 19";
          "${mod}+Control+0" = "workspace number 20";

          # Move container to workspace
          "${mod}+Control+Shift+1" = "move container to workspace number 11";
          "${mod}+Control+Shift+2" = "move container to workspace number 12";
          "${mod}+Control+Shift+3" = "move container to workspace number 13";
          "${mod}+Control+Shift+4" = "move container to workspace number 14";
          "${mod}+Control+Shift+5" = "move container to workspace number 15";
          "${mod}+Control+Shift+6" = "move container to workspace number 16";
          "${mod}+Control+Shift+7" = "move container to workspace number 17";
          "${mod}+Control+Shift+8" = "move container to workspace number 18";
          "${mod}+Control+Shift+9" = "move container to workspace number 19";
          "${mod}+Control+Shift+0" = "move container to workspace number 20";

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

        gaps = {
          bottom = cfg.proportions.gaps.outer;
          top = 0;
          left = cfg.proportions.gaps.outer;
          right = cfg.proportions.gaps.outer;

          inner = cfg.proportions.gaps.inner;
          # outer = cfg.proportions.gaps.outer; 
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
          "type:pointer" = {
            pointer_accel = "-0.675";
            accel_profile = "flat";
          };
        };

        output = {
          "${displ1}" = {
            mode = "3440x1440@175Hz";
            pos = "2560 0";
            allow_tearing = "yes";
            adaptive_sync = "no";
            render_bit_depth = "10";
          };

          "${displ2}" = {
            mode = "2560x1440@165Hz";
            pos = "0 0";
            # allow_tearing = "yes";
            adaptive_sync = "no";
            render_bit_depth = "10";
          };

          "eDP-1" = {
            mode = "1920x1080@60Hz";
            pos = "0 0";
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
