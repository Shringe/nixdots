{ config, lib, pkgs, unstablePkgs, ... }:
with lib;
let
  cfg = config.nixosModules.drivers.nvidia;
in
{
  config = mkIf cfg.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [
          rocmPackages.clr
        ];
      };

      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        modesetting.enable = true;

        powerManagement = {
          enable = false;
          # finegrained = true;
        }; 

        open = true;

        nvidiaSettings = true;
      };
    };

    # Once the package gets merged into nixpkgs
    environment.systemPackages = [
      unstablePkgs.nvidia_oc
      pkgs.steam-run
    ];

    systemd.services.nvidia_oc = {
      description = "NVIDIA Overclocking Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.steam-run}/bin/steam-run ${unstablePkgs.nvidia_oc}/bin/nvidia_oc set --index 0 --power-limit 242000 --freq-offset 112 --mem-offset 2600";
        User = "root";
        Restart = "on-failure";
      };
    };

    nixpkgs.config.cudaSupport = true;
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
