{ config, lib, ... }:
with lib;
let
  cfg = cobfig.nixosModules.maintenance.nix;
in {
  options.nixosModules.maintenance.nix = {
    enable = mkEnableOption "All nix maintenance";
  };
}
