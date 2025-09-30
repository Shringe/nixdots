{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.hyprshot;
in
{
  options.homeManagerModules.desktop.windowManagers.hyprland.hyprshot = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.hyprland.enable;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.tmpfiles.rules = [
      "d %h/Pictures/screenshots/hyprland 0755"
    ];

    programs.hyprshot = {
      enable = true;
      saveLocation = "$HOME/Pictures/screenshots/hyprland";
    };
  };
}
