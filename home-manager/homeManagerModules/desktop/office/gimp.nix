{ conig, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.office.gimp;
in {
  options.homeManagerModules.desktop.office.gimp = {
    enable = mkEnableOption "gimp";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gimp
    ];
  };
}
