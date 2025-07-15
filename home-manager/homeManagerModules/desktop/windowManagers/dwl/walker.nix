{ config, lib, inputs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.dwl.walker;
in {
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  options.homeManagerModules.desktop.windowManagers.dwl.walker = {
    enable = mkOption {
      type = types.bool;
      # default = config.homeManagerModules.desktop.windowManagers.dwl.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    homeManagerModules.desktop.windowManagers.utils.wofi.enable = mkForce false;

    programs.walker = {
      enable = true;
      runAsService = true;

      # config = {
      #
      # };
      
      # style = '''';
    };
  };
}
