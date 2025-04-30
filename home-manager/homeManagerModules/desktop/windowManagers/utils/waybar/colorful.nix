{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.waybar.colorful;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.waybar.colorful = {
    enable = mkEnableOption "Colorful waybar config";

    wm = mkOption {
      type = types.string;
      default = config.homeManagerModules.desktop.windowManagers.utils.waybar.wm;
    };
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      
      settings.primary = {
        layer = "top";
        position = "top";
        height = 24;

        modules-left = [ 
          "battery" 
          "cpu" 
          "memory" 
          "privacy"
          "${cfg.wm}/mode"
          "${cfg.wm}/window"
        ];

        modules-center = [ 
          "${cfg.wm}/workspaces" 
        ];

        modules-right = [ 
          "tray" 
          "custom/hyprsunset"
          "cava"
          "pulseaudio" 
          "network" 
          "custom/notification"
          "clock" 
        ];

        "privacy" = {
          modules = [
            { type = "screenshare"; }
            # { type = "audio-in"; } Disabled because it constantly detects the monitoring of the cava widget
          ];
        };

        "cava" = {
          framerate = 30;
          hide_on_silence = true;
          autosens = 1;
          # sensitivity = 50;
          bars = 12;
          # lower_cutoff_freq = 50;
          # higher_cutoff_freq = 10000;
          # method = "pulse";
          method = "pipewire";
          source = "auto";
          stereo = true;
          reverse = false;
          bar_delimiter = 0;
          # monstercat = true;
          # waves = false;
          # noise_reduction = 0.77;
          # input_delay = 2;
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          # actions = {
          #   on-click-right = "mode";
          # };
        };

        "${cfg.wm}/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
        };

        # "${cfg.wm}/workspaces" = {
        #   disable-scroll = true;
        #   all-outputs = false;
        #   format = "{icon}";
        #   "format-icons" = {
        #     "1" = "";
        #     "2" = "";
        #     "3" = "";
        #     "4" = "";
        #     "5" = "";
        #     "6" = "";
        #     urgent = "";
        #     focused = "";
        #     default = "";
        #   };
        # };

        "${cfg.wm}/window" = {
          icon = true;
        };

        "custom/notification" = {
          # tooltip = false;
          format = "{} {icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "custom/hyprsunset" = {
          # interval = "once";
          on-click = "pidof hyprsunset || hyprsunset -t 2600";
          on-click-right = "pkill hyprsunset";
          # signal = 1;
          # return-type = "json";
          format = "🌙";
          # tooltip-format = "hyprsunset: {alt}";
          tooltip-format = "Enable hyprsunset";
          # format-icons = {
          #   # off = "☀️";
          #   # on = "🌙";
          # };
        };

        tray = {
          spacing = 5;
        };

        clock = {
          "format" = " {:%a %d %b  %I:%M %p}";
          # "format-alt" = "{:%Y-%m-%d}";
        };

        cpu = {
          format = "{usage}% ";
        };

        memory = {
          format = "{}% ";
        };

        battery = {
          bat = "BAT0";
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          "format-icons" = [ "" "" "" "" "" ];
        };

        network = {
          "format-wifi" = "{essid} ({signalStrength}%) ";
          "format-ethernet" = "{ifname}: {ipaddr}/{cidr} ";
          "format-disconnected" = "Disconnected ⚠";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          "format-bluetooth" = "{volume}% {icon}";
          "format-muted" = "{volume}% 🔇";
          "format-icons" = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" ];
          };
          "on-click" = "pavucontrol";
          "on-click-right" = "media-control volume_mute";
        };
      };

      style = with config.lib.stylix.colors; ''
        * {
            border: none;
            border-radius: 0;
            font-family: "JetBrains Mono";
            font-size: 14px;
            min-height: 0;
        }

        window#waybar {
            background: #${base00};
            color: #${base05};
        }

        #window {
            font-weight: bold;
            color: #${base05};
        }
        /*
        #workspaces {
            padding: 0 5px;
        */

        #workspaces button {
            padding: 0 5px;
            color: #${base03};
        }

        #workspaces button.focused {
            color: #${base0E};
        }

        #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #mode, #custom-notification, #custom-hyprsunset, #mode {
            padding: 0 3px;
            color: #${base05};
            margin: 0 2px;

            font-weight: bold;
        }

        #mode {
            color: #${base01};
            background: #${base0F};
        }

        #custom-notification {
            background: #${base07};
            color: #${base01};
        }

        #custom-hyprsunset {
          margin: 0 0px;
          padding: 0 4px;
        }

        #tray {
          margin: 0 0px;
          padding: 0 0px;
        }

        #clock {
            font-weight: bold;
            color: #${base01};
            background: #${base06};
        }

        #battery {
        }

        #battery icon {
            color: #${base08};
        }

        #battery.charging {
        }

        @keyframes blink {
            to {
                background-color: #ffffff;
                color: #${base01};
            }
        }

        #battery.warning:not(.charging) {
            color: #${base05};
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #cpu {
            color: #${base01};
            background: #${base08};
        }

        #memory {
            color: #${base01};
            background: #${base09};
        }

        #network {
            color: #${base01};
            background: #${base0C};
        }

        #network.disconnected {
            background: #${base0A};
            color: #${base01};
        }

        #pulseaudio, #cava {
            background: #${base0B};
            color: #${base01};
        }

        #pulseaudio {
            ; margin: 0 2px;
            ; padding: 0 3px;
        }

        #cava {
            margin: 0 0px;
            ; padding: 0 3px;
        }

        #pulseaudio.muted {
            background: #${base0A};
            color: #${base01};
        }
      '';
    };
  };
}
