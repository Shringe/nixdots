{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.plugins;
in
{
  options.homeManagerModules.desktop.windowManagers.hyprland.plugins = {
    enable = mkOption {
      type = types.bool;
      # default = config.homeManagerModules.desktop.windowManagers.hyprland.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
        # hyprtrails
        hyprexpo
        hyprscrolling
      ];

      settings = {
        plugin = {
          hyprtrails.color = rgb "base07";
          hyprscrolling = {
            fullscreen_on_one_column = true;
            column_width = 0.7;
            focus_fit_method = 1;
          };
        };

        bind = [
          # Plugins
          "$mod, f, hyprexpo:expo, toggle"
          "$mod, j, exec, hyprctl keyword general:layout scrolling"
        ];
      };
    };
  };
}
