{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.gaming.alvr;
in
{
  options.nixosModules.gaming.alvr = {
    enable = mkOption {
      type = types.bool;
      # default = config.nixosModules.gaming.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.monado.enable = true;
    services.wivrn = {
      enable = true;
      openFirewall = true;
    };
  };
}
