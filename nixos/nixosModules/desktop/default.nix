{ lib, ... }:
with lib;
{
  imports = [
    ./windowManagers
    ./adb.nix
    ./syncthing.nix
    ./compat.nix
  ];

  options.nixosModules.desktop = {
    enable = mkEnableOption "desktop utilities, usually graphical";
  };
}
