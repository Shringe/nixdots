{ config, lib, pkgs,... }:
let
  cfg = config.nixosModules.drivers.nvidia;
in
{
  hardware = lib.mkIf cfg.enable {
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
  environment.systemPackages = lib.mkIf cfg.enable [
    pkgs.nvidia_oc
    pkgs.steam-run
  ];

  systemd.services.nvidia_oc = lib.mkIf cfg.enable {
    description = "NVIDIA Overclocking Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.steam-run}/bin/steam-run ${pkgs.nvidia_oc}/bin/nvidia_oc set --index 0 --power-limit 242000 --freq-offset 115 --mem-offset 2600";
      User = "root";
      Restart = "on-failure";
    };
  };

  services.xserver.videoDrivers = lib.mkIf cfg.enable [ "nvidia" ];
}
