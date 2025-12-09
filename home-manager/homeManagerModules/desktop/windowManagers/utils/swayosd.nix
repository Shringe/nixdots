{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.swayosd;
  targets = config.homeManagerModules.desktop.windowManagers.utils.systemd.waylandTargets;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.swayosd = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.swayosd = {
      Install.WantedBy = mkForce targets;

      Unit = {
        After = mkForce targets;
        PartOf = mkForce targets;
      };
    };

    services.swayosd = {
      enable = true;
    };
  };
}
