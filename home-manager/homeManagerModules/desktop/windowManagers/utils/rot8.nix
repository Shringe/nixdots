{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.rot8;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.rot8 = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.rot8 = {
      Unit = {
        Description = "Starts rot8 for screen auto rotation.";
        PartOf = [ config.wayland.systemd.target ];
        After = [ config.wayland.systemd.target ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${pkgs.rot8}/bin/rot8";
        Restart = "on-failure";
      };

      # Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
