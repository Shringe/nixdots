{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.swaybg;
  targets = config.homeManagerModules.desktop.windowManagers.utils.systemd.waylandTargets;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.swaybg = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.swaybg = {
      Unit = {
        Description = "Sets wallpaper with SwayBG";
        PartOf = targets;
        After = targets;
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg --mode fill --image ${config.stylix.image}";
        Restart = "on-failure";
      };

      Install.WantedBy = targets;
    };
  };
}
