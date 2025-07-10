{ lib, ... }:
with lib;
{
  imports = [
    ./windowManagers
  ];

  options.nixosModules.desktop = {
    enable = mkEnableOption "desktop utilities, usually graphical";
  };
}
