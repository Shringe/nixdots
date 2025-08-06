{ lib, config, ... }:
let
  cfg = config.homeManagerModules.shells.atuin;
in {
  sops.secrets = {
    "atuin/session" = {};
    "atuin/key" = {};
  };

  programs.atuin = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      session_path = config.sops.secrets."atuin/session".path;
      key_path = config.sops.secrets."atuin/key".path;

      sync_address = "https://atuin.deamicis.top";
      enter_accept = true;

      style = "compact";
      inline_height = 20;
    };
  };
}
