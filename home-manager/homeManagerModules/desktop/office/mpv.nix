{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.office.mpv;
in
{
  options.homeManagerModules.desktop.office.mpv = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.office.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
    };
  };
}
