{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.bluetooth;
in
{
  options.nixosModules.hardware.bluetooth = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    blueman = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to also enable blueman service";
    };
  };

  config = mkIf cfg.enable {
    services.blueman.enable = cfg.blueman;
    hardware.bluetooth.enable = true;
  };
}
