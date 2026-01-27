{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.office.extraQt;
in
{
  options.homeManagerModules.desktop.office.extraQt = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.office.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.freetube.enable = true;

    home.packages = mkMerge [
      (with pkgs.kdePackages; [
        korganizer
        okular
        dolphin
        ark
        accounts-qt
        akonadi
        kdepim-runtime
        gwenview
        elisa
        isoimagewriter
      ])

      (with pkgs; [
        haruna
        qtscrcpy
        lxqt.pavucontrol-qt
      ])
    ];
  };
}
