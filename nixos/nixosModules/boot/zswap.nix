{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.boot.zswap;
in
{
  options.nixosModules.boot.zswap = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [
      "zswap.enabled=1" # enables zswap
      "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure
    ];
  };
}
