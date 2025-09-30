{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.cliphist;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.cliphist = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.enable;
    };
  };

  config = {
    home.packages =
      with pkgs;
      mkIf cfg.enable [
        wl-clipboard
        cliphist
      ];

    services.cliphist = mkIf cfg.enable {
      enable = true;
      allowImages = true;
      systemdTargets = [
        "hyprland-session.target"
        "wlroots-session.target"
      ];

      extraOptions = [
        "-max-items"
        "300"
      ];
    };
  };
}
