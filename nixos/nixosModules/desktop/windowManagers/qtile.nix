{ config, lib, ...  }:
let
  cfg = config.nixosModules.desktop.windowManagers.qtile;
in
{
  services.xserver.windowManager.qtile = lib.mkIf cfg.enable {
    enable = true;
    extraPackages = python3Packages: with python3Packages; [
      qtile-extras
    ];
  };
}
