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
    
    style = ''
      @define-color base      #${config.lib.stylix.colors.base00};
      @define-color mantle    #${config.lib.stylix.colors.base01};
      @define-color surface0  #${config.lib.stylix.colors.base02};
      @define-color surface1  #${config.lib.stylix.colors.base03};
      @define-color surface2  #${config.lib.stylix.colors.base04};
      @define-color text      #${config.lib.stylix.colors.base05};
      @define-color rosewater #${config.lib.stylix.colors.base06};
      @define-color lavender  #${config.lib.stylix.colors.base07};
      @define-color red       #${config.lib.stylix.colors.base08};
      @define-color peach     #${config.lib.stylix.colors.base09};
      @define-color yellow    #${config.lib.stylix.colors.base0A};
      @define-color green     #${config.lib.stylix.colors.base0B};
      @define-color teal      #${config.lib.stylix.colors.base0C};
      @define-color blue      #${config.lib.stylix.colors.base0D};
      @define-color mauve     #${config.lib.stylix.colors.base0E};
      @define-color flamingo  #${config.lib.stylix.colors.base0F};

      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrains Mono";
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background: @base;
          color: @text;
      }

      #window {
          font-weight: bold;
          color: @text;
      }
      /*
      #workspaces {
          padding: 0 5px;
      */

      #workspaces button {
          padding: 0 5px;
          color: @mauve;
      }

      #workspaces button.focused {
          color: @surface1;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-spotify, #tray, #mode, #custom-notification {
          padding: 0 5px;
          color: @text;
          margin: 0 2px;
          border-radius: 8px;

          font-weight: bold;
      }

      #custom-notification {
          background: @lavender;
          color: @mantle;
      }

      #clock {
          font-weight: bold;
          color: @mantle;
          background: @rosewater;
      }

      #battery {
      }

      #battery icon {
          color: @red;
      }

      #battery.charging {
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: @mantle;
          }
      }

      #battery.warning:not(.charging) {
          color: @text;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #cpu {
          color: @mantle;
          background: @red;
          border-radius: 8px;
      }

      #memory {
          color: @mantle;
          background: @peach;
          border-radius: 8px;
      }

      #network {
          color: @mantle;
          background: @teal;
          border-radius: 8px;
      }

      #network.disconnected {
          background: @yellow;
          color: @mantle;
          border-radius: 8px;
      }

      #pulseaudio {
          background: @green;
          color: @mantle;
          border-radius: 8px;
      }

      #pulseaudio.muted {
          background: @yellow;
          color: @mantle;
          border-radius: 8px;
      }

      #custom-spotify {
          color: rgb(102, 220, 105);
      }

      #tray {
      }
    '';

    settings.primary = {
      layer = "top";
      position = "top";
      height = 24;

      modules-left = [ 
        # "custom/spotify" 
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
        "pulseaudio" 
        "network" 
        "custom/notification"
        "clock" 
      ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = false;
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
  };
}
