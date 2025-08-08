{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.apps;
in
{
  options.homeManagerModules.desktop.apps = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    # Avoids having to pass -b bac to nh home switch
    home.file."${config.xdg.dataHome}/mimeapps.list".force = true;

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [
          "org.pwmt.zathura.desktop"
          "firefox.desktop"
        ];

        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "text/html" = [ "firefox.desktop" ];

        "image/png" = [ "feh.desktop" ];
        "image/jpg" = [ "feh.desktop" ];
        "image/jpeg" = [ "feh.desktop" ];
        "image/webm" = [ "feh.desktop" ];
        "image/webp" = [ "feh.desktop" ];
      };
    };
  };
}
