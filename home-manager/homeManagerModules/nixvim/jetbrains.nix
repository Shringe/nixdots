{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.nixvim.jetbrains;
in
{
  options.homeManagerModules.nixvim.jetbrains = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.nixvim.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs.jetbrains; [
      idea
      rider
    ];
  };
}
