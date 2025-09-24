{ lib, ... }:
with lib;
{
  imports = [
    ./windowManagers
    ./adb.nix
    ./syncthing.nix
  ];

  options.nixosModules.desktop = {
    enable = mkEnableOption "desktop utilities, usually graphical";
  };
}
