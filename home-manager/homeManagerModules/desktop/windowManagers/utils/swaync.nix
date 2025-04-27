{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.swaync;
in {
  options.homeManagerModules.desktop.windowManagers.utils.swaync = {
    enable = mkEnableOption "Sway notification center";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      swaynotificationcenter
    ];

    services.swaync = mkIf cfg.enable {
      enable = true;

      settings = {
        positionX = "right";
        positionY = "top";

        layer = "overlay";

        control-center-margin-top = 10;
        control-center-margin-bottom = 10;
        control-center-margin-right = 10;
        control-center-margin-left = 10;

        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;

        timeout = 3;
        timeout-low = 2;
        timeout-critical = 5;

        fit-to-screen = false;
        control-center-width = 500;
        control-center-height = 1025;
        notification-window-width = 440;
        keyboard-shortcuts = true;
        image-visibility = "when-available";
        transition-time = 200;

        hide-on-clear = true;
        hide-on-action = true;
        script-fail-notify = true;

        widgets = [
          "title"
          "dnd"
          "notifications"
          "mpris"
          "volume"
          "buttons-grid"
        ];

        widget-config = {
          title = {
            text = "Notification Center";
            clear-all-button = true;
            button-text = "󰆴 Clear All";
          };

          dnd = {
            text = "Do Not Disturb";
          };

          label = {
            max-lines = 1;
            text = "Notification Center";
          };

          mpris = {
            image-size = 96;
            image-radius = 7;
          };

          volume = {
            label = "󰕾";
            show-per-app = true;
          };

          buttons-grid = {
            actions = [
              {
                label = "󰐥";
                command = "systemctl poweroff";
              }
              {
                label = "󰜉";
                command = "systemctl reboot";
              }
              {
                label = "󰌾";
                command = "${pkgs.swaylock}/bin/swaylock";
              }
              {
                label = "󰍃";
                command = "${pkgs.sway}/bin/swaymsg exit";
              }
              {
                label = "󰤄";
                command = "systemctl suspend";
              }
              # {
              #   label = "󰕾";
              #   command = "swayosd-client --output-volume mute-toggle";
              # }
              # {
              #   label = "󰍬";
              #   command = "swayosd-client --input-volume mute-toggle";
              # }
              # {
              #   label = "󰖩";
              #   command = "$HOME/.local/bin/shved/rofi-menus/wifi-menu.sh";
              # }
              # {
              #   label = "󰂯";
              #   command = "blueman-manager";
              # }
              # {
              #   label = "";
              #   command = "obs";
              # }
            ];
          };
        };
      };

      style = with config.lib.stylix.colors; ''
        @define-color cc-bg              #${base00};
        @define-color noti-bg            #${base02};
        @define-color noti-bg-darker     #${base01};
        @define-color text-color         #${base05};
        @define-color text-color-alt     #${base05};
        @define-color accent             #${base0E};
        @define-color accent-hover       #${base0D};
        @define-color border-color       #${base07};
        @define-color dnd-bg             #${base02};
        @define-color dnd-checked-bg     #${base0A};

        * {
            font-family: JetBrainsMono NFP;
            font-weight: bold;
            font-size: 14px;
        }

        .control-center .notification-row:focus,
        .control-center .notification-row:hover {
            opacity: 1;
            background: @noti-bg-darker;
        }

        .notification-row {
            outline: none;
            margin: 20px;
            padding: 0;
        }

        .notification {
            background: transparent;
            margin: 0px;
        }

        .notification-content {
            background: @cc-bg;
            padding: 7px;
            border-radius: 0px;
            margin: 0;
        }

        .close-button {
            background: @accent;
            color: @cc-bg;
            text-shadow: none;
            padding: 0;
            border-radius: 0px;
            margin-top: 5px;
            margin-right: 5px;
        }

        .close-button:hover {
            box-shadow: none;
            background: @accent-hover;
            transition: all .15s ease-in-out;
            border: none;
        }

        .notification-action {
            color: @text-color-alt;
            border: 2px solid @border-color;
            border-top: none;
            border-radius: 0px;
            background: @cc-bg;
        }

        .notification-default-action:hover,
        .notification-action:hover {
            color: @text-color-alt;
            background: @cc-bg;
        }

        .summary {
            padding-top: 7px;
            font-size: 13px;
            color: @text-color-alt;
        }

        .time {
            font-size: 11px;
            color: @accent;
            margin-right: 24px;
        }

        .body {
            font-size: 12px;
            color: @text-color-alt;
        }

        .control-center {
            background: @cc-bg;
            border: 2px solid @border-color;
            border-radius: 0px;
        }

        .control-center-list,
        .floating-notifications {
            background: transparent;
        }

        .control-center-list-placeholder {
            opacity: .5;
        }

        .blank-window {
            background: alpha(black, 0.2);
        }

        .widget-title {
            color: @text-color;
            background: @noti-bg-darker;
            padding: 5px 10px;
            margin: 10px 10px 5px 10px;
            font-size: 1.5rem;
            border-radius: 5px;
        }

        .widget-title>button {
            font-size: 1rem;
            color: @text-color;
            text-shadow: none;
            background: @noti-bg;
            box-shadow: none;
            border-radius: 5px;
        }

        .widget-title>button:hover {
            background: @accent;
            color: @cc-bg;
        }

        .widget-dnd {
            background: @noti-bg-darker;
            padding: 5px 10px;
            margin: 5px 10px 10px 10px;
            border-radius: 5px;
            font-size: large;
            color: @text-color;
        }

        .widget-dnd>switch {
            border-radius: 4px;
            background: @dnd-bg;
        }

        .widget-dnd>switch:checked {
            background: @dnd-checked-bg;
            border: 1px solid @dnd-checked-bg;
        }

        .widget-dnd>switch slider,
        .widget-dnd>switch:checked slider {
            background: @cc-bg;
            border-radius: 5px;
        }

        .widget-label {
            margin: 10px 10px 5px 10px;
        }

        .widget-label>label {
            font-size: 1rem;
            color: @text-color;
        }

        .widget-mpris {
            color: @text-color;
            background: @noti-bg-darker;
            padding: 5px 10px 0px 0px;
            margin: 5px 10px 5px 10px;
            border-radius: 0px;
        }

        .widget-mpris > box > button {
            border-radius: 5px;
        }

        .widget-mpris-player {
            padding: 5px 10px;
            margin: 10px;
        }

        .widget-mpris-title {
            font-weight: 700;
            font-size: 1.25rem;
        }

        .widget-mpris-subtitle {
            font-size: 1.1rem;
        }

        .widget-buttons-grid {
            font-size: x-large;
            padding: 5px;
            margin: 5px 10px 10px 10px;
            border-radius: 5px;
            background: @noti-bg-darker;
        }

        .widget-buttons-grid>flowbox>flowboxchild>button {
            margin: 3px;
            background: @cc-bg;
            border-radius: 5px;
            color: @text-color;
        }

        .widget-buttons-grid>flowbox>flowboxchild>button:hover {
            background: @accent;
            color: @cc-bg;
        }

        .widget-menubar>box>.menu-button-bar>button,
        .topbar-buttons>button {
            border: none;
            background: transparent;
        }
      '';
    };
  };
}
