{ inputs, lib, config, ... }:
let
  cfg = config.homeManagerModules.shells.atuin;
in
{
  programs.atuin = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      key_path = config.sops.secrets.atuin_key.path;
    };
  };

  sops.secrets.atuin_key = {};
  sops.secrets.atuin_key.sopsFile = ../../../secrets.yaml;
}
