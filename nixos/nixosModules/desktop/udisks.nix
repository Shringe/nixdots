{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.desktop.udisks;
in
{
  options.nixosModules.desktop.udisks = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.desktop.enable;
      description = "Allows graphical mounting of drives";
    };
  };

  config = mkIf cfg.enable {
    services.udisks2.enable = true;
  };
}
