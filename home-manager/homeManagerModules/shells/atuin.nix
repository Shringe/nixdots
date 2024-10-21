{ lib, config, ... }:
{
  config.programs.atuin = lib.mkIf config.homeManagerModules.shells.atuin.enable {
    enable = true;
  };
}
