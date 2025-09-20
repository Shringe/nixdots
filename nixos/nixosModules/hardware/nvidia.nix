{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.hardware.nvidia;
in
{
  options.nixosModules.hardware.nvidia = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

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
        open = true;
        nvidiaSettings = true;
      };
    };

    # Once the package gets merged into nixpkgs
    environment.systemPackages = with pkgs; [
      nvidia_oc
      steam-run
      nvtopPackages.full
    ];

    systemd.services.nvidia_oc = {
      description = "NVIDIA Overclocking Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.steam-run}/bin/steam-run ${pkgs.nvidia_oc}/bin/nvidia_oc set --index 0 --power-limit 242000 --freq-offset 112 --mem-offset 2600";
        User = "root";
        RemainAfterExit = true;
      };
    };

    nixpkgs.config.cudaSupport = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    # This has prebuilt cuda packages
    nix.settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
