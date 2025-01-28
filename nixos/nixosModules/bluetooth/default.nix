{ config, lib, ... }:
let 
  cfg = config.nixosModules.bluetooth;
in
{
  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
    };
  };
}
