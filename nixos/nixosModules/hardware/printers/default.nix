{ lib, ... }:
with lib;
{
  imports = [
    ./brother.nix
  ];

  options.nixosModules.hardware.printers = {
    enable = mkEnableOption "default printer";
  };
}
