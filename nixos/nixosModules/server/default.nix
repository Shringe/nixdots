{ lib, ... }:
with lib;
{
  imports = [
    ./router
    ./ssh
    ./networking
  ];

  options.nixosModules.server = {
    enable = mkEnableOption "hosting all server services";
  };
}
