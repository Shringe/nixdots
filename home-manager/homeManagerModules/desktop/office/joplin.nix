{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.office.joplin;
in {
  options.homeManagerModules.desktop.office.joplin = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.office.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.joplin-desktop = {
      enable = true;
    };
  };
}
