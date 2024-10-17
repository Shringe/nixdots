{ config, lib, ... }:
{
  imports = [
    ./bash.nix
    ./fish.nix
    ./aliases.nix
    ./atuin.nix
  ];

  options.shells.enable = lib.mkEnableOption "Enable all shells and shell configuration";
  config.shells = lib.mkIf config.shells.enable {
    fish = {
      enable = lib.mkDefault true;
      # atuin = lib.mkDefault true;
    };
    aliases.enable = lib.mkDefault true;
    atuin.enable = lib.mkDefault true;
  };
}
