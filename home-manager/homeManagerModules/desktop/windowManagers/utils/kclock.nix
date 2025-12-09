{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.kclock;
  targets = config.homeManagerModules.desktop.windowManagers.utils.systemd.waylandTargets;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.kclock = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kdePackages.kclock
    ];

    systemd.user.services.kclockd = {
      Unit = {
        Description = "Runs kclock daemon";
        PartOf = targets;
        After = targets;
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${pkgs.kdePackages.kclock}/bin/kclockd";
        Restart = "on-failure";
      };

      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
