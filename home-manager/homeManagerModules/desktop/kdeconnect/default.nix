{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.kdeconnect;
in
{
  config = mkIf cfg.enable {
    services.kdeconnect = {
      enable = true;
      indicator = mkDefault false;
    };
  };
}
