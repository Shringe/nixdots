{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl.wlogout;
in {
  options.homeManagerModules.desktop.windowManagers.dwl.wlogout = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.dwl.enable;
      # default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.wlogout = {
      enable = true;

      style = ''
        * {
          background-image: none;
          box-shadow: none;
        }

        window {
          background-color: rgba(30, 30, 46, 0.90);
        }

        button {
          border-radius: 0;
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

        #lock {
          background-image: url("${./../../../../../assets/icons/wlogout/lavender/lock.svg}");
        }

        #logout {
          background-image: url("${./../../../../../assets/icons/wlogout/lavender/logout.svg}");
        }

        #suspend {
          background-image: url("${./../../../../../assets/icons/wlogout/lavender/suspend.svg}");
        }

        #hibernate {
          background-image: url("${./../../../../../assets/icons/wlogout/lavender/hibernate.svg}");
        }

        #shutdown {
          background-image: url("${./../../../../../assets/icons/wlogout/lavender/shutdown.svg}");
        }

        #reboot {
          background-image: url("${./../../../../../assets/icons/wlogout/lavender/reboot.svg}");
        }
      '';
    };
  };
}
