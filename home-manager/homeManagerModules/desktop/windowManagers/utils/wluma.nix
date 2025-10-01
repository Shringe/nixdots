{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.wluma;
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
        PartOf = mkForce [
          "wlroots-session.target"
          "hyprland-session.target"
        ];
        After = mkForce [
          "wlroots-session.target"
          "hyprland-session.target"
        ];
      };
      Install.WantedBy = mkForce [
        "wlroots-session.target"
        "hyprland-session.target"
      ];
    };

    services.wluma.enable = true;
  };
}
