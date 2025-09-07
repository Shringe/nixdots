{ lib, config, ... }:
with lib;
let
  cfg = config.nixosModules.hardware.kanata;
in
{
  options.nixosModules.hardware.kanata = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables full kanata keyboard configuration.";
    };

    variant = mkOption {
      type = types.str;
      default = "wide";
      description = "What .kbd file to use. Options can be found in ./kanata/";
    };
  };

  config = mkIf cfg.enable {
    services.kanata = {
      enable = true;
      keyboards.default = {
        configFile = ./${cfg.variant}.kbd;
        extraArgs = [ "--quiet" ];
      };
    };
  };
}
