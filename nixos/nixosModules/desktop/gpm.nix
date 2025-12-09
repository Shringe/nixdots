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
      default = true;
    };
  };

  config = mkIf cfg.enable {
    services.gpm.enable = true;
  };
}
