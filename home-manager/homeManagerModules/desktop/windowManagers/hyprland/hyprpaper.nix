{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.hyprpaper;
in
{
  options.homeManagerModules.desktop.windowManagers.hyprland.hyprpaper = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.hyprland.enable;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.hyprpaper = {
      Install.WantedBy = mkForce [ "hyprland-session.target" ];
      Unit = {
        After = mkForce [ "hyprland-session.target" ];
        PartOf = mkForce [ "hyprland-session.target" ];
      };
    };

    services.hyprpaper.enable = true;
  };
}
