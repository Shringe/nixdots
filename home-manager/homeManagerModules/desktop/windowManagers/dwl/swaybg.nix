{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl.swaybg;
in {
  options.homeManagerModules.desktop.windowManagers.dwl.swaybg = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.dwl.enable;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.swaybg = {
      Unit = {
        Description = "Sets wallpaper with SwayBG";
        PartOf = [ config.wayland.systemd.target ];
        After = [ config.wayland.systemd.target ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg --mode fill --image ${config.stylix.image}";
        Restart = "on-failure";
      };

      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
