{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.printing;
in
{
  options.homeManagerModules.desktop.printing = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      system-config-printer
      simple-scan
    ];
  };
}
