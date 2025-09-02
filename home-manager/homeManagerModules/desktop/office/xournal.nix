{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.office.xournal;
in
{
  options.homeManagerModules.desktop.office.xournal = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.office.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xournalpp
    ];
  };
}
