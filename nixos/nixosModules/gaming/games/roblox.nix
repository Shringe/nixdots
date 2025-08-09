{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.gaming.games.roblox;
in
{
  config = mkIf cfg.enable {

  };
}
