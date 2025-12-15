{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.wlogout;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.wlogout = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.wleave = {
      enable = true;

      settings = {
        no-version-info = true;
        margin = 200;
        buttons-per-row = "3";
        delay-command-ms = 500;
        close-on-lost-focus = true;
        show-keybinds = true;
        buttons = [
          {
            label = "lock";
            action = "loginctl lock-session";
            text = "Lock";
            keybind = "l";
            icon = "${./../../../../../assets/icons/wlogout/lavender/lock.svg}";
          }
          {
            label = "logout";
            action = "loginctl terminate-user $USER";
            text = "Logout";
            keybind = "e";
            icon = "${./../../../../../assets/icons/wlogout/lavender/logout.svg}";
          }
          {
            label = "suspend";
            action = "systemctl suspend-then-hibernate";
            text = "Suspend";
            keybind = "u";
            icon = "${./../../../../../assets/icons/wlogout/lavender/suspend.svg}";
          }
          {
            label = "hibernate";
            action = "systemctl hibernate";
            text = "Hibernate";
            keybind = "h";
            icon = "${./../../../../../assets/icons/wlogout/lavender/hibernate.svg}";
          }
          {
            label = "shutdown";
            action = "systemctl poweroff";
            text = "Shutdown";
            keybind = "s";
            icon = "${./../../../../../assets/icons/wlogout/lavender/shutdown.svg}";
          }
          {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
            icon = "${./../../../../../assets/icons/wlogout/lavender/reboot.svg}";
          }
        ];
      };

      style = ''
        * {
          background-image: none;
          box-shadow: none;
          border-radius: 8;
        }

        window {
          background-color: rgba(30, 30, 46, 0.60);
        }

        button {
          border-color: #b4befe;
          text-decoration-color: #cdd6f4;
          color: #cdd6f4;
          background-color: #181825;
          border-style: solid;
          border-width: 1px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
        }

        button:focus, button:active, button:hover {
          /* 20% Overlay 2, 80% mantle */
          background-color: rgb(48, 50, 66);
          outline-style: none;
        }
      '';
    };
  };
}
