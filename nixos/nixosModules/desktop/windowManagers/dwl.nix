{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.desktop.windowManagers.dwl;
in {
  options.nixosModules.desktop.windowManagers.dwl = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.desktop.windowManagers.enable;
    };
  };

  config = mkIf cfg.enable {
    # Needed for hacky desktop entry
    environment.systemPackages = with pkgs; [
      sdwl
    ];

    services.displayManager.sessionPackages = optional cfg.enable pkgs.dwl;
  };
}
