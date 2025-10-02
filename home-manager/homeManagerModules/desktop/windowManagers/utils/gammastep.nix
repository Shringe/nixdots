{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.gammastep;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.gammastep = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.enable;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.gammastep = {
      Unit = {
        Description = "Starts gammastep for blue light filter.";
        PartOf = [ config.wayland.systemd.target ];
        After = [ config.wayland.systemd.target ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${pkgs.gammastep}/bin/gammastep -O 3600";
        ExecPost = "${pkgs.gammastep}/bin/gammastep -x";
        Restart = "on-failure";
      };

      # Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
