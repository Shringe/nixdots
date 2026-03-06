{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.niri.dms;
  target = "niri.service";
in
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  options.homeManagerModules.desktop.windowManagers.niri.dms = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.niri.enable;
      # default = false;
    };

    laptopMode = mkOption {
      type = types.bool;
      default = false;
      description = "Enable things like battery indicators and power saving features";
    };
  };

  config = mkIf cfg.enable {
    programs.dank-material-shell = {
      enable = true;

      systemd = {
        enable = true;
        target = target;
      };
    };
  };
}
