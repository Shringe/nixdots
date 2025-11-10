{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.waybar.matte;

  # color definitions
  active     = config.lib.stylix.colors.base0D;
  highlight  = config.lib.stylix.colors.base07;
  text       = config.lib.stylix.colors.base05;
  # text       = config.lib.stylix.colors.base07;
  background = config.lib.stylix.colors.base00;
  widget     = config.lib.stylix.colors.base02;
in {
  options.homeManagerModules.desktop.windowManagers.utils.waybar.matte = {
    enable = mkEnableOption "Sleek waybar config";

    wm = mkOption {
      type = types.str;
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
          "${cfg.wm}/window"
        ];

        modules-center = [ 
          "${cfg.wm}/workspaces" 
        ];

        modules-right = [ 
          "tray" 
          # "cava"
          "custom/hyprsunset"
          "pulseaudio" 
          "network" 
          "custom/notification"
          "clock" 
        ];

        "cava" = {
          framerate = 30;
          autosens = 1;
          sensitivity = 50;
          bars = 14;
          lower_cutoff_freq = 50;
          higher_cutoff_freq = 10000;
          method = "pulse";
          source = "auto";
          stereo = true;
          reverse = false;
          bar_delimiter = 0;
          monstercat = false;
          waves = false;
          noise_reduction = 0.77;
          input_delay = 2;
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          actions = {
            on-click-right = "mode";
          };
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
          exec-if = "which ${cfg.wm}nc-client";
          exec = "${cfg.wm}nc-client -swb";
          on-click = "${cfg.wm}nc-client -t -sw";
          on-click-right = "${cfg.wm}nc-client -d -sw";
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

      style = ''
        * {
            border: none;
            border-radius: 0;
            font-family: "JetBrains Mono";
            font-size: 14px;
            min-height: 0;
        }

        window#waybar {
            background: #${background};
            color: #${text};
        }

        #window {
            font-weight: bold;
            color: #${text};
        }
        /*
        #workspaces {
            padding: 0 5px;
        */

        #workspaces button {
            padding: 0 5px;
            color: #${widget};
        }

        #workspaces button.focused {
            color: #${text};
        }

        #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #mode, #custom-notification, #custom-hyprsunset {
            padding: 0 3px;
            background: #${widget};
            color: #${text};
            margin: 0 2px;

            font-weight: bold;
        }

        #custom-notification {
        }

        #custom-hyprsunset {
            margin: 0 0px;
        }

        #clock {
            font-weight: bold;
            color: #${text};
            background: #${widget};
        }

        #battery {
        }

        #battery icon {
            color: #${widget};
        }

        #battery.charging {
        }

        @keyframes blink {
            to {
                background-color: #ffffff;
                color: #${config.lib.stylix.colors.base01};
            }
        }

        #battery.warning:not(.charging) {
            color: #${text};
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #cpu {
        }

        #memory {
        }

        #network {
        }

        #network.disconnected {
        }

        #pulseaudio {
        }

        #pulseaudio.muted {
        }

        #tray {
            margin: 0 0px;
        }
      '';
    };
  };
}
