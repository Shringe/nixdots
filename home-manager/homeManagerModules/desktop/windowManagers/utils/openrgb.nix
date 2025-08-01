{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.openrgb;
in {
  options.homeManagerModules.desktop.windowManagers.utils.openrgb = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.openrgb = {
      Unit = {
        Description = "Sets RGB with OpenRGB";
        PartOf = [ config.wayland.systemd.target ];
        Requires = [ "tray.target" ];
        After = [
          config.wayland.systemd.target
          "tray.target"
        ];
      };

      Service = {
        # We use the current system path because either openrgb-with-plugins or openrgb may be installed
        ExecStart = "/run/current-system/sw/bin/openrgb --startminimized";
        Restart = "on-failure";
      };

      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
