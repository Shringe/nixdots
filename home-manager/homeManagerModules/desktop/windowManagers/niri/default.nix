{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.niri;
in
{
  imports = [
    ./waybar
    ./dms
    ./hyprlax.nix
  ];

  options.homeManagerModules.desktop.windowManagers.niri = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.enable;
    };

    monitors = {
      primary = mkOption {
        type = types.str;
        default = "eDP-1";
      };

      secondary = mkOption {
        type = types.str;
        default = cfg.monitors.primary;
      };
    };
  };

  config = mkIf cfg.enable {
    services.swayidle.systemdTarget = "niri.service";
    homeManagerModules.desktop.windowManagers.utils = {
      systemd = {
        enable = true;
        waylandTargets = [ "niri.service" ];
      };

      swayidle = {
        enable = false;
        turnOffScreenCmd = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        turnOnScreenCmd = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      };

      # wofi.enable = true;
      walker.enable = false;
      swaync.enable = false;
      cliphist.enable = false;
      swayosd.enable = false;
      dolphin.enable = true;
      wluma.enable = false;
      kclock.enable = true;
      polkit.enable = false;
      hyprlock.enable = false;
      wlogout.enable = false;
      swaybg.enable = false;
    };

    # home.packages = with pkgs; [
    #   niri
    # ];

    xdg.configFile."niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "/nixdots/home-manager/homeManagerModules/desktop/windowManagers/niri/config.kdl";

    xdg.configFile."niri/vars.kdl".text = with config.lib.stylix.colors.withHashtag; ''
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
    '';
  };
}
