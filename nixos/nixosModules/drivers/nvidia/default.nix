{ config, lib, pkgs,... }:
let
  cfg = config.nixosModules.drivers.nvidia;
in
{
  hardware = lib.mkIf cfg.enable {
    graphics.enable = true;

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;

      powerManagement = {
        enable = false;
        # finegrained = true;
      }; 

      open = false;

      nvidiaSettings = true;
    };
  };

  # Once the package gets merged into nixpkgs
  environment.systemPackages = lib.mkIf cfg.enable [
    # pkgs.nvidia_oc
  ];

  services.xserver.videoDrivers = lib.mkIf cfg.enable [ "nvidia" ];
}
