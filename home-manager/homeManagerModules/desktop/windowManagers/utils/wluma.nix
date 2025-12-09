{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.wluma;
  targets = config.homeManagerModules.desktop.windowManagers.utils.systemd.waylandTargets;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.wluma = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.wluma = {
      Unit = {
        PartOf = mkForce targets;
        After = mkForce targets;
      };

      Install.WantedBy = mkForce targets;
    };

    services.wluma.enable = true;
  };
}
