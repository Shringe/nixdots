{ config, lib, ... }:
let
  cfg = config.nixosModules.drivers.nvidia;
in
{
  nixpkgs.config = lib.mkIf cfg.enable {
    # allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    #   "nvidia-x11"
    #   "nvidia-settings"
    #   "nvidia-persistenced"
    # ];
    allowUnfree = true;
  };

  hardware = lib.mkIf cfg.enable {
    graphics.enable = true;

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;

      powerManagement = {
        enable = false;
        # finegrained = true;
      }; 

      open = false;

      nvidiaSettings = true;
    };
  };

  services.xserver.videoDrivers = lib.mkIf cfg.enable [ "nvidia" ];
}
