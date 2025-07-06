{ lib, ... }:
with lib;
{
  imports = [
    ./router
    ./ssh
  ];

  options.nixosModules.server = {
    enable = mkEnableOption "hosting all server services";
  };
}
