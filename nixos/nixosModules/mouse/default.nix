{ config, lib, ... }:
let
  cfg = config.nixosModules.mouse;
in
{
  services.libinput.mouse = lib.mkIf cfg.main.enable {
    accelProfile = "flat";
    accelSpeed = "-1.0";
  };
}
