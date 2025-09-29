{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.swayosd;
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
      Install.WantedBy = mkForce [ "grahpical-session.target" ];
      Unit = {
        After = mkForce [ "grahpical-session.target" ];
        PartOf = mkForce [ "grahpical-session.target" ];
      };
    };

    services.swayosd = {
      enable = true;
    };
  };
}
