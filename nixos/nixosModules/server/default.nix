{ lib, ... }:
with lib;
{
  imports = [
    ./router
    ./ssh
    ./networking
    ./services
  ];

  options.nixosModules.server = {
    enable = mkEnableOption "hosting all server services";
  };
}
