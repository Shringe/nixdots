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
    home.packages = with pkgs.kdePackages; [
      kate
      okular
      ark

      # Dolphin and required dependencies
      dolphin
      kio
      kdf
      kio-fuse
      kio-extras
      kio-admin
      qtwayland
      plasma-integration
      kdegraphics-thumbnailers
      breeze-icons
      qtsvg
      kservice
      pkgs.shared-mime-info
    ];
  };
}
