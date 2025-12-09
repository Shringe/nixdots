{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.desktop.gpm;
in
{
  options.nixosModules.desktop.gpm = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    services.gpm.enable = true;
  };
}
