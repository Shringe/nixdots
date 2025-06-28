{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.apps;
in {
  options.homeManagerModules.desktop.apps = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "image/png" = [ "feh.desktop" ];
        "image/jpg" = [ "feh.desktop" ];
        "image/jpeg" = [ "feh.desktop" ];
        "image/webm" = [ "feh.desktop" ];
        "image/webp" = [ "feh.desktop" ];
      };
    };
  };
}
