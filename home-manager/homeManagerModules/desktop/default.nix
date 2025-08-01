{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop;
in {
  imports = [
    ./browsers
    ./office
    ./terminals
    ./windowManagers
    ./email
    ./discord
    ./music
    ./kdeconnect
    ./apps
    ./matrix
    ./printing
  ];

  options.homeManagerModules.desktop = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
}
