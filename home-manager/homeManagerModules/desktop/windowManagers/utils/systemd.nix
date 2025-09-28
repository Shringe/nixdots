{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.systemd;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.systemd = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    wayland.systemd.target = "wlroots-session.target";
    systemd.user.targets.wlroots-session.Unit = {
      Description = "wlroots compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };
}
