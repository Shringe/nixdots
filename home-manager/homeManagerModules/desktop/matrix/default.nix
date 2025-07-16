{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.matrix;
in {
  options.homeManagerModules.desktop.matrix = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.enable; 
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."desktop/matrix/iamb" = {
      path = "${config.home.homeDirectory}/.config/iamb/config.toml";
    };

    programs = {
      element-desktop.enable = true;
      iamb.enable = true;
    };
  };
}
