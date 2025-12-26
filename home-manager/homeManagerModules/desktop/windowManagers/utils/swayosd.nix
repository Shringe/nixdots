{
  config,
  lib,
  pkgs,
  ...
}:
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

      stylePath = pkgs.writeText "style.css" (
        with config.lib.stylix.colors.withHashtag;
        # with config.stylix.opacity;
        ''
          window#osd {
            border-radius: 8px;
            border: 2px solid ${base07};
            background: ${base00};
          }
        ''
      );
    };
  };
}
