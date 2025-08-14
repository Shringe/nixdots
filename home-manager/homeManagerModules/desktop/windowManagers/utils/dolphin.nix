{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.dolphin;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.dolphin = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # Enable XDG MIME and menu support
    xdg.mime.enable = true;

    # Fix for empty "Open With" menu in Dolphin when running under Hyprland
    # This copies the plasma-applications.menu file from plasma-workspace to /etc/xdg/menus/applications.menu
    xdg.configFile."menus/applications.menu".source =
      "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

    # Additional KDE-specific packages
    home.packages = with pkgs; [
      kdePackages.kate
      kdePackages.okular

      # Dolphin and required dependencies
      kdePackages.dolphin
      kdePackages.kio
      kdePackages.kdf
      kdePackages.kio-fuse
      kdePackages.kio-extras
      kdePackages.kio-admin
      kdePackages.qtwayland
      kdePackages.plasma-integration
      kdePackages.kdegraphics-thumbnailers
      kdePackages.breeze-icons
      kdePackages.qtsvg
      kdePackages.kservice
      shared-mime-info
    ];
  };
}
