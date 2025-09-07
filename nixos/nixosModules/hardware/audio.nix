{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.hardware.audio;
in
{
  options.nixosModules.hardware.audio = {
    enable = mkOption {
      type = type.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
  };
}
