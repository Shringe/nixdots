{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.hyprpolkit;
in
{
  options.homeManagerModules.desktop.windowManagers.hyprland.hyprpolkit = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.hyprland.enable;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.hyprpolkitagent = {
      Install.WantedBy = mkForce [ "hyprland-session.target" ];
      Unit = {
        After = mkForce [ "hyprland-session.target" ];
        PartOf = mkForce [ "hyprland-session.target" ];
      };
    };

    services.hyprpolkitagent.enable = true;
  };
}
