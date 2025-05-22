{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.kdeconnect;
in
{
  config = lib.mkIf cfg.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
