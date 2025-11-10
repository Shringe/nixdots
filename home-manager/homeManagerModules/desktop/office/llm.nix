{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.office.llm;
in
{
  options.homeManagerModules.desktop.office.llm = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.office.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jan
    ];
  };
}
