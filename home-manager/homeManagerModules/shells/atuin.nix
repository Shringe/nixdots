{ lib, config, ... }:
let
  cfg = config.homeManagerModules.shells.atuin;
in
{
  programs.atuin = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      key_path = config.sops.secrets.atuin_key.path;
      # sync_address = "http://192.168.0.165:47200";
      sync_address = "https://atuin.deamicis.top";
      enter_accept = true;

      style = "compact";
      inline_height = 20;
    };
  };

  sops.secrets.atuin_key = {};
}
