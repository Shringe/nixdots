{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.gaming.emulators;
in
{
  options.nixosModules.gaming.emulators = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cemu
      torzu
      mesen
    ];
  };
}
