{ config, lib, pkgs,... }:
let
  cfg = config.nixosModules.drivers.nvidia;
in
{
  # nixpkgs.config = lib.mkIf cfg.enable {
  #   # allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   #   "nvidia-x11"
  #   #   "nvidia-settings"
  #   #   "nvidia-persistenced"
  #   # ];
  #   allowUnfree = true;
  # };
  #
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

  programs.tuxclocker = lib.mkIf cfg.enable {
    enable = true;
    useUnfree = true;
    enabledNVIDIADevices = [ 0 ];
  };

  services.xserver.videoDrivers = lib.mkIf cfg.enable [ "nvidia" ];
}
