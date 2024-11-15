{ inputs, lib, config, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  programs.atuin = lib.mkIf config.homeManagerModules.shells.atuin.enable {
    enable = true;
    settings = {
      key_path = config.sops.secrets.atuin.path;
    };
  };
  sops.secrets.atuin.sopsFile = ../secrets.yaml;
}
