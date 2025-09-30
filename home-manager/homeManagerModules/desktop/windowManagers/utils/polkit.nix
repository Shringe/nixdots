{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.polkit;
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
      Install.WantedBy = mkForce [
        "wlroots-session.target"
      ];

      Unit = {
        After = mkForce [
          "wlroots-session.target"
        ];

        PartOf = mkForce [
          "wlroots-session.target"
        ];
      };
    };

    services.polkit-gnome = {
      enable = true;
    };
  };
}
