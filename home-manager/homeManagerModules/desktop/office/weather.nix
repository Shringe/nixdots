{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.office.weather;
in
{
  options.homeManagerModules.desktop.office.weather = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.office.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mousam
    ];
  };
}
