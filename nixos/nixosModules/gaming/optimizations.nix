{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.gaming.optimizations;
in {
  config = mkIf cfg.enable {
    boot = {
      tmp.useTmpfs = true;

      # kernelPackages = pkgs.linuxKernel.kernels.linux_zen;
      kernelPackages = pkgs.linuxPackages_zen;
    };

    environment.sessionVariables = {
      __GL_MaxFramesAllowed = "1";
    };

    programs.gamemode.enable = true;
  };
}
