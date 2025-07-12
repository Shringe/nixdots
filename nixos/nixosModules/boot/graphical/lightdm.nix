{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.boot.graphical.lightdm;
in {
  options.nixosModules.boot.graphical.lightdm = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

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
