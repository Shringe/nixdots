{ config, lib, ...  }:
let
  cfg = config.nixosModules.desktop.qtile;
in
{
  services.xserver.windowManager.qtile = {
    enable = true;
    extraPackages = python3Packages: with python3Packages; [
      qtile-extras
    ];
  };
}
