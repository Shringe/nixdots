{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeManagerModules.desktop.windowManagers.niri;

  # string `echo arg1 arg2` -> string `"echo" "arg1" "arg2"`
  quoteWords = s: lib.concatMapStringsSep " " (w: ''"${w}"'') (lib.splitString " " s);
in
{
  imports = [
    ./waybar
    ./quickshell
    ./hyprlax.nix
  ];

  options.homeManagerModules.desktop.windowManagers.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.homeManagerModules.desktop.windowManagers.enable;
    };

    monitors = {
      primary = lib.mkOption {
        type = lib.types.str;
        default = "eDP-1";
      };

      secondary = lib.mkOption {
        type = lib.types.str;
        default = cfg.monitors.primary;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.swayidle.systemdTarget = "niri.service";
    homeManagerModules.desktop.windowManagers.utils = {
      systemd = {
        enable = true;
        waylandTargets = [ "niri.service" ];
      };

      swayidle = {
        enable = true;
        turnOffScreenCmd = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        turnOnScreenCmd = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      };

      # wofi.enable = true;
      walker.enable = true;
      swaync.enable = false;
      cliphist.enable = true;
      swayosd.enable = true;
      dolphin.enable = true;
      wluma.enable = true;
      kclock.enable = true;
      polkit.enable = true;
      hyprlock.enable = true;
      wlogout.enable = true;
      swaybg.enable = true;
    };

    home.packages = with pkgs; [
      xwayland-satellite
    ];

    xdg.configFile."niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "/nixdots/home-manager/homeManagerModules/desktop/windowManagers/niri/config.kdl";

    xdg.configFile."niri/immutable.kdl".text = with config.lib.stylix.colors.withHashtag; ''
      window-rule {
        border {
          // active-gradient from="#80c8ff" to="#bbddff" angle=45
          // inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
          // urgent-gradient from="#800" to="#a33" angle=45

          active-gradient from="${base07}" to="${base0E}" angle=45
          inactive-color "${base03}"
          urgent-gradient from="${base03}" to="${base0C}" angle=45
        }

        shadow {
          color "${base00}99"
        }
      }

      cursor {
        xcursor-theme "${config.stylix.cursor.name}"
        xcursor-size ${toString config.stylix.cursor.size}
      }

      binds {
        Mod+S hotkey-overlay-title="Run an Application: walker" { spawn ${quoteWords config.homeManagerModules.desktop.windowManagers.utils.walker.cmd}; }
      }
    '';
  };
}
