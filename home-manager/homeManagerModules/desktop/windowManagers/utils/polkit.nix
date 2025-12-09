{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.polkit;
  targets = config.homeManagerModules.desktop.windowManagers.utils.systemd.waylandTargets;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.polkit = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.polkit-gnome = {
      Install.WantedBy = mkForce targets;

      Unit = {
        After = mkForce targets;
        PartOf = mkForce targets;
      };
    };

    services.polkit-gnome = {
      enable = true;
    };
  };
}
