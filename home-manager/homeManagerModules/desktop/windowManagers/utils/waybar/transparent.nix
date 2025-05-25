{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.waybar.transparent;
  nordvpn = "${config.shared.packages.nordvpn}/bin/nordvpn";

  nordstatus = (pkgs.writeShellApplication {
    name = "nordstatus";

    text = ''
      #!/usr/bin/env sh
      if ${nordvpn} status | ${pkgs.gnugrep}/bin/grep -q 'Status: Connected'; then
        ${nordvpn} status | ${pkgs.gawk}/bin/awk -F': ' '/Country:/ {print $2}'
      else
        echo "Off"
      fi
    '';
  });
in
{
  options.homeManagerModules.desktop.windowManagers.utils.waybar.transparent = {
    enable = mkEnableOption "Colorful waybar config";

    wm = mkOption {
      type = types.string;
      default = config.homeManagerModules.desktop.windowManagers.utils.waybar.wm;
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.waybar.enable = false;

    homeManagerModules.desktop.windowManagers.utils.waybar = {
      colorful.enable = mkForce false;
      matte.enable = mkForce false;
    };

    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "sway-session.target";
      };
      
      settings.primary = {
        layer = "top";
        position = "top";
        height = 20;

        modules-left = [ 
          "cpu" 
          "memory" 
          "battery" 
          "privacy"
          "custom/nordvpn"
          "${cfg.wm}/mode"
          "${cfg.wm}/window"
        ];

        modules-center = [ 
          "${cfg.wm}/workspaces" 
        ];

        modules-right = [ 
          "tray" 
          "custom/hyprsunset"
          "mpris"
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
          # icon = true;
          icon = false;
        };

        "mpris" = {
          format = "{title}";

          status-icons = {
            playing = "▶";
            paused = "⏸";
          };
        };

        "custom/nordvpn" = {
          format = "VPN: {}";
          interval = 5;
          exec = "${nordstatus}/bin/nordstatus";
          on-click = "${nordvpn} connect";
          on-click-right = "${nordvpn} disconnect";
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
          exec-if = "${pkgs.coreutils}/bin/which swaync-client";
          exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
          on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
          escape = true;
        };

        "custom/hyprsunset" = {
          # interval = "once";
          on-click = "${pkgs.procps}/bin/pidof gammastep || ${pkgs.gammastep}/bin/gammastep -O 3200";
          on-click-right = "${pkgs.procps}/bin/pkill gammastep";
          # signal = 1;
          # return-type = "json";
          format = "🌙";
          # tooltip-format = "hyprsunset: {alt}";
          tooltip-format = "Enable blue-light-filter.";
          # format-icons = {
          #   # off = "☀️";
          #   # on = "🌙";
          # };
        };

        tray = {
          spacing = mkForce 2;
        };

        clock = {
          "format" = "{:%a %d %b  %I:%M %p} ";
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

      style = with config.lib.stylix.colors.withHashtag; with config.stylix.opacity; ''
        @define-color b00 ${base00};
        @define-color b01 ${base01};
        @define-color b02 alpha(${base02}, ${toString desktop});
        @define-color b03 ${base03};
        @define-color b04 ${base04};
        @define-color b05 ${base05};
        @define-color b06 ${base06};
        @define-color b07 ${base07};
        @define-color b08 ${base08};
        @define-color b09 ${base09};
        @define-color b0A ${base0A};
        @define-color b0B ${base0B};
        @define-color b0C ${base0C};
        @define-color b0D ${base0D};
        @define-color b0E ${base0E};
        @define-color b0F ${base0F};

        * {
          border: none;
          font-family: "JetBrains Mono";
          font-size: 14px;
          min-height: 0;
          border-radius: 0px;
          padding-left: 6px;
          padding-right: 6px;
          padding-top: 1px;
        }

        window#waybar {
          background: transparent;
          color: @b05;
        }

        #cpu, #memory, #pulseaudio, #cava, #mpris, #tray, #mode, #custom-hyprsunset, #mode, #custom-nordvpn, #battery, #network, #custom-notification, #clock, #window {
          color: @b05;
          font-weight: bold;
        }

        #window {
        }

        .modules-left {
          background: @b02;
          margin-left: 4px;
          border-radius: 8px;
        }
        .modules-right {
          background: @b02;
          margin-right: 4px;
          border-radius: 8px;
        }
        .modules-center {
          background: @b02;
          padding-right: 3px;
          padding-left: 3px;
          border-radius: 8px;
        }

        #pulseaudio, #cava, #mpris {
          color: @b0B;
        }

        #workspaces {
          padding-top: 0px;
          padding-bottom: 0px;
        }

        #workspaces button {
          padding-top: 0px;
          padding-bottom: 0px;
          border-bottom: 3px solid transparent;
          color: @b03;
        }
        #workspaces button.focused,
        #workspaces button.active {
          padding-top: 0px;
          color: @b0E;
          padding-bottom: 0px;
          border-bottom: 3px solid @base0E;
        }

        #cpu {
          color: @b08;
        }

        #memory {
          color: @b09;
        }

        #window {
          color: @b05;
        }

        #mode {
          color: @b01;
          background: @b0F;
        }

        #custom-hyprsunset {
          margin-left: 0px;
          padding-left: 2px;
        }

        #tray {
          padding-left: 0px;
          padding-right: 0px;
          margin-right: 0px;
          margin-left: 0px;
          border-radius: 0px;
        }

        #battery {
          color: @b0D;
        }

        #custom-nordvpn {
          color: @b05;
        }

        #network {
          color: @b0C;
        }

        #pulseaudio.muted, #network.disconnected {
          color: @b0A;
        }

        #clock {
          color: @b06;
        }

        #custom-notification {
          color: @b07;
        }

        @keyframes blink {
          to {
            background-color: #ffffff;
            color: @b01;
          }
        }

        #battery.warning:not(.charging) {
          color: @b05;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
      '';
    };
  };
}
