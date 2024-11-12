{ lib, config, inputs, ... }:
{
  imports = [
    inputs.agenix.homeManagerModules.default
  ];
  programs.atuin = lib.mkIf config.homeManagerModules.shells.atuin.enable {
    enable = true;
    settings = {
      # key_path = config.
      # key_path = config.age.secrets.atuin.path;
    };
  };
  age.secrets.atuin.file = ../../../secrets/atuin.age;
}
