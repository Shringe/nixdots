{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.swaync;
  targets = config.homeManagerModules.desktop.windowManagers.utils.systemd.waylandTargets;
  scripts = config.homeManagerModules.desktop.windowManagers.utils.scripts;

  mkToggleService = onCmd: offCmd: {
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = onCmd;
      ExecStop = offCmd;
    };
  };

  serviceTest = pkgs.writers.writeDashBin "serviceTest" ''
    if [ "$2" = true ]; then
      ${pkgs.systemd}/bin/systemctl --user --quiet is-active "$1" && echo false || echo true
    else
      ${pkgs.systemd}/bin/systemctl --user --quiet is-active "$1" && echo true || echo false
    fi

  '';

  serviceToggle = pkgs.writers.writeDashBin "serviceToggle" ''
    if [ "$2" = true ]; then
      state="false"
    else
      state="true"
    fi

    if [ "$SWAYNC_TOGGLE_STATE" = "$state" ]; then
      ${pkgs.systemd}/bin/systemctl --user --no-block start "$1"
    else
      ${pkgs.systemd}/bin/systemctl --user --no-block stop "$1"
    fi
  '';
in
{
  options.homeManagerModules.desktop.windowManagers.utils.swaync = {
    enable = mkEnableOption "Sway notification center";

    widgets = {
      touchpad = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };

        device = mkOption {
          type = types.str;
          default = "msft0001:01-04f3:3138-touchpad";
          description = "Hyprland touchpad to turn off";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.swaync.enable = false;

    # home.packages = with pkgs; [
    # swaynotificationcenter
    # ];

    systemd.user.services = {
      disable_touchpad = mkIf cfg.widgets.touchpad.enable (
        mkToggleService "${pkgs.hyprland}/bin/hyprctl keyword 'device[${cfg.widgets.touchpad.device}]:enabled' false" "${pkgs.hyprland}/bin/hyprctl keyword 'device[${cfg.widgets.touchpad.device}]:enabled' true"
      );

      enable_touchpad_while_typing = mkIf cfg.widgets.touchpad.enable (
        mkToggleService "${pkgs.hyprland}/bin/hyprctl keyword 'input:touchpad:disable_while_typing' false" "${pkgs.hyprland}/bin/hyprctl keyword 'input:touchpad:disable_while_typing' true"
      );
    };

    systemd.user.services.swaync = {
      Install.WantedBy = mkForce targets;

      Unit = {
        After = mkForce targets;
        PartOf = mkForce targets;
      };

      Service.Environment =
        with pkgs;
        "PATH=$PATH:${
          makeBinPath [
            scripts.toggleGammastep
            serviceToggle
            serviceTest

            coreutils
            procps
            hyprlock
            wleave
            swaynotificationcenter
            systemd
          ]
        }";
    };

    services.swaync = mkIf cfg.enable {
      enable = true;

      settings = {
        positionX = "right";
        positionY = "top";

        control-center-margin-top = 10;
        control-center-margin-bottom = 10;
        control-center-margin-right = 10;
        control-center-margin-left = 10;

        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;

        timeout = 8;
        timeout-low = 4;
        timeout-critical = 0;

        normal_window = true;

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
          "buttons-grid"
          "mpris"
          "volume"
          "backlight"
          "notifications"
        ];

        widget-config = {
          backlight = {
            label = "🔆";
            device = "intel_backlight";
          };

          title = {
            text = "Notification Center";
            clear-all-button = true;
            button-text = "󰆴 Clear All";
          };

          label = {
            max-lines = 1;
            text = "Notification Center";
          };

          mpris = {
            image-size = 96;
            image-radius = 8;
          };

          volume = {
            label = "󰕾";
            show-per-app = true;
          };

          buttons-grid = {
            actions = [
              # {
              #   label = "󰐥";
              #   command = "systemctl poweroff";
              # }
              # {
              #   label = "󰜉";
              #   command = "systemvctl reboot";
              # }
              # {
              #   label = "󰌾";
              #   command = "loginctl lock-session";
              # }
              {
                label = "󰍃";
                command = "wleave";
              }
              {
                label = "󰤄";
                type = "toggle";
                active = false;
                command = "serviceToggle gammastep";
                update-command = "serviceTest gammastep";
              }
              {
                label = "🗘";
                type = "toggle";
                active = false;
                command = "serviceToggle rot8";
                update-command = "serviceTest rot8";
              }
              {
                # label = "🔆";
                label = "󰃡";
                type = "toggle";
                active = false;
                command = "serviceToggle wluma true";
                update-command = "serviceTest wluma true";
              }
              {
                label = "☕";
                # lebel = "󰐨";
                type = "toggle";
                active = false;
                command = "serviceToggle hypridle true";
                update-command = "serviceTest hypridle true";
              }

              {
                active = false;
                label = "";
                type = "toggle";
                command = "swaync-client --toggle-dnd";
                update-command = "swaync-client --get-dnd";
              }

              # {
              #   label = "󰤄";
              #   command = script "toggleGammastep";
              # }
              # {
              #   label = "󰕾";
              #   command = "swayosd-client --output-volume mute-toggle";
              # }
              # {
              #   label = "󰍬";
              #   command = "swayosd-client --input-volume mute-toggle";
              # }
              #
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
            ]
            ++ optionals cfg.widgets.touchpad.enable [
              {
                active = false;
                label = "🖱";
                type = "toggle";
                command = "serviceToggle disable_touchpad";
                update-command = "serviceTest disable_touchpad";
              }
              {
                active = false;
                label = "🎮";
                type = "toggle";
                command = "serviceToggle enable_touchpad_while_typing";
                update-command = "serviceTest enable_touchpad_while_typing";
              }
            ];
          };
        };
      };

      style =
        with config.lib.stylix.colors.withHashtag;
        with config.stylix.opacity;
        ''
          @define-color base00 alpha(${base00}, ${toString desktop});
          @define-color base01 alpha(${base01}, ${toString desktop});
          @define-color base02 alpha(${base02}, ${toString desktop});
          @define-color base03 alpha(${base03}, ${toString desktop});
          @define-color base04 alpha(${base04}, ${toString desktop});
          @define-color base05 alpha(${base05}, ${toString desktop});
          @define-color base06 alpha(${base06}, ${toString desktop});
          @define-color base07 alpha(${base07}, ${toString desktop});
          @define-color base08 alpha(${base08}, ${toString desktop});
          @define-color base09 alpha(${base09}, ${toString desktop});
          @define-color base0A alpha(${base0A}, ${toString desktop});
          @define-color base0B alpha(${base0B}, ${toString desktop});
          @define-color base0C alpha(${base0C}, ${toString desktop});
          @define-color base0D alpha(${base0D}, ${toString desktop});
          @define-color base0E alpha(${base0E}, ${toString desktop});
          @define-color base0F alpha(${base0F}, ${toString desktop});

          @define-color cc-bg              @base00;
          @define-color noti-bg            @base02;
          @define-color noti-bg-darker     @base01;
          @define-color text-color         @base05;
          @define-color text-color-alt     @base05;
          @define-color accent             @base0E;
          @define-color accent-hover       @base0D;
          @define-color border-color       @base07;
          @define-color dnd-bg             @base02;
          @define-color dnd-checked-bg     @base0A;
          @define-color border             @base0D;


          * {
              font-family: JetBrainsMono NFP;
              font-weight: bold;
              font-size: 14px;
              border-radius: 8px;
          }


          .control-center .notification-row:focus,
          .control-center .notification-row:hover {
              # opacity: 1;
              background: @noti-bg-darker;
          }

          .notification-row {
              outline: none;
              margin: 20px;
              padding: 0;
          }

          .notification {
              background: @base00;
              font-size: 14px;

              margin: 0px;
              padding: 8px;
              padding-top: 6px;
              padding-bottom: 12px;
          }

          # .notification-content {
          #     background: @cc-bg;
          #     padding: 7px;
          #     margin: 0;
          # }

          .close-button {
              background: @accent;
              color: @cc-bg;
              text-shadow: none;
              padding: 0;
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
              border-top: none;
              background: @cc-bg;
          }

          .blank-window {
              background: transparent;
          }

          .notification-default-action:hover,
          .notification-action:hover {
              color: @text-color-alt;
              background: @cc-bg;
          }

          .notification.low {
              border: 2px solid @base0E;
          }

          .notification.normal {
              border: 2px solid @base0D;
          }

          .notification.critical {
              border: 2px solid @base08;
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
          }

          .control-center-list,
          .floating-notifications {
              background: transparent;
          }

          .control-center-list-placeholder {
              # opacity: .5;
          }

          .widget-title {
              color: @text-color;
              background: @noti-bg-darker;
              padding: 5px 10px;
              margin: 10px 10px 5px 10px;
              font-size: 1.5rem;
          }

          .widget-title>button {
              font-size: 1rem;
              color: @text-color;
              text-shadow: none;
              background: @noti-bg;
              box-shadow: none;
          }

          .widget-title>button:hover {
              background: @accent;
              color: @cc-bg;
          }

          .widget-dnd {
              background: @noti-bg-darker;
              padding: 5px 10px;
              margin: 5px 10px 10px 10px;
              font-size: large;
              color: @text-color;
          }

          .widget-dnd>switch {
              background: @dnd-bg;
          }

          .widget-dnd>switch:checked {
              background: @dnd-checked-bg;
              border: 1px solid @dnd-checked-bg;
          }

          .widget-dnd>switch slider,
          .widget-dnd>switch:checked slider {
              background: @cc-bg;
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
              padding: 5px 10px 0px 0px;
              margin: 5px 10px 5px 10px;
          }

          .widget-mpris > box > button {
          }

          .widget-mpris-player {
              padding: 5px 10px;
              margin: 10px;

              background: @base01;
              border: 1px solid @border;
          }

          .widget-mpris-player button:hover {
              background: @accent-hover;
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
              # padding: 5px;
              # margin: 5px 10px 10px 10px;
              border-radius: 5px;
              background: @noti-bg-darker;

              margin: 3px;
              padding: 4px 30px;
              transition: background-color 0.15s ease-in-out;
          }

          .widget-buttons-grid>flowbox>flowboxchild>button {
              margin: 0;
              padding: 8px 36px;
              background: @cc-bg;
              color: @text-color;
          }

          .toggle:checked {
              margin: 0;
              padding: 8px 36px;
              background: @accent-hover;
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
