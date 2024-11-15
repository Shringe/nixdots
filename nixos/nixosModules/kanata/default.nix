{ lib, config, ... }:
{
  services.kanata = lib.mkIf config.nixosModules.kanata.enable {
    enable = true;
    keyboards.default = {
      configFile = ./kanata.kbd;
    };
  };
}
