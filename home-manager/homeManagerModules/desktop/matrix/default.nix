{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.matrix;
in
{
  options.homeManagerModules.desktop.matrix = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.enable;
    };

    extra = mkOption {
      type = types.bool;
      default = true;
      description = "Extra matrix clients.";
    };
  };

  config = mkIf cfg.enable {
    programs = mkIf cfg.extra {
      element-desktop.enable = true;
      nheko.enable = true;
    };
  };
}
