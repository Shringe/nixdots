{ lib, ... }:
with lib;
{
  imports = [
    ./brotherhl2280dw.nix
  ];

  options.nixosModules.hardware.printers = {
    enable = mkEnableOption "default printer";
  };
}
