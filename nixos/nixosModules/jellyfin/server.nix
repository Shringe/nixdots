{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.jellyfin.server;
in
{
  config = lib.mkIf cfg.enable {

  };
}
