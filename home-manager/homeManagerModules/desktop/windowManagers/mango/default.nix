{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.mango;
in
{
  imports = [
    inputs.mango.homeModules.mango
  ];

  options.homeManagerModules.desktop.windowManagers.mango = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.enable;
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.mango = {
      enable = true;
    };
  };
}
