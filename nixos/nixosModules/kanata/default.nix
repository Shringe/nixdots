{ lib, config, ... }:
let
  cfg = config.nixosModules.kanata;
in
{
  services.kanata = lib.mkIf cfg.enable {
    enable = true;
    keyboards.default = {
      configFile = ./${cfg.variant}.kbd;
      extraArgs = [ "--quiet" ];
    };
  };
}
