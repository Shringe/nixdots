{
  config,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.walker;
in
{
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  options.homeManagerModules.desktop.windowManagers.utils.walker = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
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
