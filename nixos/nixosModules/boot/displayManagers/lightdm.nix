{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.boot.displayManagers.lightdm;
in {
  config = mkIf cfg.enable {
    services.xserver.displayManager.lightdm = {
      enable = true;

      greeters.slick = {
        enable = true;
        extraConfig = ''
          clock-format="%a %d %b %I:%M %p"
        '';
      };
    };
  };
}
