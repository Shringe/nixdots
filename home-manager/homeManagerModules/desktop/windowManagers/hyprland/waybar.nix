{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.waybar;
in
{
  home.packages = with pkgs; lib.mkIf cfg.enable [
    fira-sans
  ];

  programs.waybar = lib.mkIf cfg.enable {
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
        "hyprland/window"
      ];

      modules-center = [ 
        "hyprland/workspaces" 
      ];

      modules-right = [ 
        "tray" 
        "custom/hyprsunset"
        "pulseaudio" 
        "network" 
        "custom/notification"
        "clock" 
      ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = false;
      };

      "hyprland/window" = {
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

      #
      # "hyprland/workspaces" = {
      #   disable-scroll = true;
      #   all-outputs = false;
      #   format = "{icon}";
      #   "format-icons" = {
      #     "1:web" = "";
      #     "2:code" = "";
      #     "3:term" = "";
      #     "4:work" = "";
      #     "5:music" = "";
      #     "6:docs" = "";
      #     urgent = "";
      #     focused = "";
      #     default = "";
      #   };
      # };

      tray = {
        spacing = 10;
      };

      clock = {
        "format" = " {:%a %d %b  %I:%M %p}";
        "format-alt" = "{:%Y-%m-%d}";
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
          background: #${config.lib.stylix.colors.base00};
          color: #${config.lib.stylix.colors.base05};
      }

      #window {
          font-weight: bold;
          color: #${config.lib.stylix.colors.base05};
      }
      /*
      #workspaces {
          padding: 0 5px;
      */

      #workspaces button {
          padding: 0 5px;
          color: #${config.lib.stylix.colors.base0E};
      }

      #workspaces button.focused {
          color: #${config.lib.stylix.colors.base03};
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #mode, #custom-notification, #custom-hyprsunset {
          padding: 0 5px;
          color: #${config.lib.stylix.colors.base05};
          margin: 0 2px;
          border-radius: 8px;

          font-weight: bold;
      }

      #custom-notification {
          background: #${config.lib.stylix.colors.base07};
          color: #${config.lib.stylix.colors.base01};
      }

      #custom-hyprsunset {

      }

      #clock {
          font-weight: bold;
          color: #${config.lib.stylix.colors.base01};
          background: #${config.lib.stylix.colors.base06};
      }

      #battery {
      }

      #battery icon {
          color: #${config.lib.stylix.colors.base08};
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
          color: #${config.lib.stylix.colors.base05};
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #cpu {
          color: #${config.lib.stylix.colors.base01};
          background: #${config.lib.stylix.colors.base08};
          border-radius: 8px;
      }

      #memory {
          color: #${config.lib.stylix.colors.base01};
          background: #${config.lib.stylix.colors.base09};
          border-radius: 8px;
      }

      #network {
          color: #${config.lib.stylix.colors.base01};
          background: #${config.lib.stylix.colors.base0C};
          border-radius: 8px;
      }

      #network.disconnected {
          background: #${config.lib.stylix.colors.base0A};
          color: #${config.lib.stylix.colors.base01};
          border-radius: 8px;
      }

      #pulseaudio {
          background: #${config.lib.stylix.colors.base0B};
          color: #${config.lib.stylix.colors.base01};
          border-radius: 8px;
      }

      #pulseaudio.muted {
          background: #${config.lib.stylix.colors.base0A};
          color: #${config.lib.stylix.colors.base01};
          border-radius: 8px;
      }

      #tray {
      }
    '';
  };
}
