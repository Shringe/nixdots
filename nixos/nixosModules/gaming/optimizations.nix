{ lib, config, pkgs, ... }:
let
  cfg = config.nixosModules.gaming.optimizations;
in
{
  boot.tmp.useTmpfs = lib.mkIf cfg.enable true;
}
