{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl.waybar.matte;
  # nordvpn = config.shared.packages.nordvpn;
  #
  # nordstatus = pkgs.writeShellApplication {
  #   name = "nordstatus";
  #
  #   runtimeInputs = with pkgs; [
  #     nordvpn
  #     gnugrep
  #     gawk
  #     coreutils
  #   ];
  #
  #   text = ''
  #     if nordvpn status | grep -q 'Status: Connected'; then
  #       nordvpn status | awk -F': ' '/Country:/ {print $2}'
  #     else
  #       echo "Off"
  #     fi
  #   '';
  # };

  leftSeparator = makeSeparator "/";
  rightSeparator = makeSeparator "/";

  makeSeparator = s: {
    format = s;
    tooltip = false;
  };

  styleLeftSeparator = n: styleSeparator "left" n;
  styleRightSeparator = n: styleSeparator "right" n;

  styleSeparator = d: n: ''
    #custom-${d}Separator${toString n} {
      font-size: 14px;
      font-weight: bold;
      color: @b04;
      padding: 0px;
      padding-left: 4px;
      padding-right: 4px;
      padding-bottom: 0px;
      padding-top: 0px;
      margin: 0px;
      margin-left: 0px;
      margin-right: 0px;
      margin-bottom: 0px;
      margin-top: 0px;
    }
  '';
in
{
  options.homeManagerModules.desktop.windowManagers.dwl.waybar.matte = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.dwl.waybar.variant == "matte";
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.waybar.enable = false;

    systemd.user.services.waybar.Service.Environment =
      with pkgs;
      mkForce "PATH=$PATH:${
        makeBinPath [
          # nordvpn
          # nordstatus
          coreutils
          procps
          swaynotificationcenter
          pavucontrol
          iwgtk
        ]
      }";

    programs.waybar = {
      enable = true;

      systemd.enable = true;

      settings.primary = {
        layer = "top";
        position = "top";
        height = 24;

        modules-left = [
          "dwl/tags"
          "custom/leftSeparator1"
          "dwl/window"
          "custom/leftSeparator2"
        ];

        modules-center = [
        ];

        modules-right = [
          "custom/rightSeparator5"
          "tray"
          "privacy"

          "custom/rightSeparator4"
          "mpris"
          "cava"
          "pulseaudio"

          "custom/rightSeparator3"
          "network"
          # "custom/nordvpn"

          "custom/rightSeparator2"
          "battery"
          "memory"
          "cpu"

          "custom/rightSeparator1"
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
          bars = 12;
          method = "pipewire";
          source = "auto";
          stereo = true;
          reverse = false;
          bar_delimiter = 0;
          format-icons = [
            "▁"
            "▂"
            "▃"
            "▄"
            "▅"
            "▆"
            "▇"
            "█"
          ];
        };

        "dwl/tags" = {
          disable-scroll = true;
          all-outputs = false;
        };

        "dwl/window" = {
          format = "{layout} => {title}";
          max-lenght = 40;
          icon = false;
          icon-size = 10;
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
          exec = "nordstatus";
          on-click = "nordvpn connect";
          on-click-right = "nordvpn disconnect";
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

        tray = {
          spacing = mkForce 5;
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
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        network = {
          "format-wifi" = "{essid} ({signalStrength}%) ";
          "format-ethernet" = "{ifname}: {ipaddr}/{cidr} ";
          "format-disconnected" = "Disconnected ⚠";
          "on-click" = "iwgtk";
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
            default = [
              ""
              ""
            ];
          };
          "on-click" = "pavucontrol";
          "on-click-right" = "wpctl set-mute @DEFAULT_SINK@ toggle";
        };

        "custom/leftSeparator1" = leftSeparator;
        "custom/leftSeparator2" = leftSeparator;

        "custom/rightSeparator1" = rightSeparator;
        "custom/rightSeparator2" = rightSeparator;
        "custom/rightSeparator3" = rightSeparator;
        "custom/rightSeparator4" = rightSeparator;
        "custom/rightSeparator5" = rightSeparator;
      };

      style =
        with config.lib.stylix.colors.withHashtag;
        with config.stylix.opacity;
        ''
          @define-color b00 ${base00};
          @define-color b01 ${base01};
          @define-color b02 ${base02};
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

          @define-color widget_background ${base00};
          @define-color bar_background ${base00};
          @define-color text ${base05};
          @define-color active ${base05};
          @define-color highlight ${base0E};


          * {
            font-family: "JetBrains Mono";
            font-size: 14px;
            border: none;
            margin-top: 0px;
            margin-bottom: 0px;
            padding-top: 0px;
            padding-bottom: 0px;
            border-top: 0px;
            border-bottom: 0px;
            border-radius: 0px;
          }

          window#waybar {
            background: @bar_background;
            color: @b05;
          }

          #cpu, #memory, #pulseaudio, #cava, #mpris, #mode, #custom-gammastep, #mode, #custom-nordvpn, #battery, #network, #custom-notification, #clock, #window, #tray {
            color: @text;
            font-weight: bold;
            padding-left: 6px;
            padding-right: 6px;
          }

          .modules-left {
            background: @widget_background;
          }
          .modules-right {
            background: @widget_background;
          }

          #tags {
            color: @text;
            font-weight: bold;
            padding-left: 2px;
            padding-right: 2px;
            margin-right: 0px;
            margin-left: 2px;
          }

          #tags button {
            color: @b03;
            font-weight: bold;
            padding-left: 2px;
            padding-right: 2px;
            margin-right: 0px;
            margin-left: 2px;
          }

          #tags button.occupied {
            color: @text;
            font-weight: bold;
            padding-left: 2px;
            padding-right: 2px;
            margin-right: 0px;
            margin-left: 2px;
          }

          #tags button.focused {
            color: @highlight;
            font-weight: bold;
            padding-left: 2px;
            padding-right: 2px;
            margin-right: 0px;
            margin-left: 2px;
            ; border-bottom: 1px solid @highlight;
            border-bottom: 0px;
          }

          #cpu {
            color: @active;
          }

          #memory {
            color: @active;
          }

          #window {
            color: @text;
          }

          #mode {
            color: @b01;
            background: @b0F;
          }

          #battery {
            color: @active;
          }

          #custom-nordvpn {
            color: @active;
          }

          #network {
            color: @active;
          }

          #pulseaudio.muted, #network.disconnected {
            color: @b0A;
          }

          #clock {
            color: @active;
          }

          #custom-notification {
            color: @active;
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

          ${styleLeftSeparator 1}
          ${styleLeftSeparator 2}

          ${styleRightSeparator 1}
          ${styleRightSeparator 2}
          ${styleRightSeparator 3}
          ${styleRightSeparator 4}
          ${styleRightSeparator 5}
        '';
    };
  };
}
