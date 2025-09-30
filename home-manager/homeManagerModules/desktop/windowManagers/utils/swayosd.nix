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
      Install.WantedBy = mkForce [
        "wlroots-session.target"
        "hyprland-session.target"
      ];

      Unit = {
        After = mkForce [
          "wlroots-session.target"
          "hyprland-session.target"
        ];

        PartOf = mkForce [
          "wlroots-session.target"
          "hyprland-session.target"
        ];
      };
    };

    services.swayosd = {
      enable = true;
    };
  };
}
