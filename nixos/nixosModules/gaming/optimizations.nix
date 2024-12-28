{ lib, config, pkgs, ... }:
let
  cfg = config.nixosModules.gaming.optimizations;
in
{
  boot = lib.mkIf cfg.enable {
    tmp.useTmpfs = true;

    # kernelPackages = pkgs.linuxKernel.kernels.linux_zen;
    kernelPackages = pkgs.linuxPackages_zen;
  };
}
