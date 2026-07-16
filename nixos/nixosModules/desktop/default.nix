{ lib, ... }:
with lib;
{
  imports = [
    ./windowManagers
    ./adb.nix
    ./syncthing.nix
    ./compat.nix
    ./gpm.nix
    ./udisks.nix
    ./localsend.nix
  ];

  options.nixosModules.desktop = {
    enable = mkEnableOption "desktop utilities, usually graphical";
  };
}
