{ config, lib, ... }:
let
  cfg = config.nixosModules.mouse;
in
{
  services.libinput = lib.mkIf cfg.main.enable {
    enable = true;

    mouse = {
      accelProfile = "flat";
      accelSpeed = "-0.675";
    };
  };
}
