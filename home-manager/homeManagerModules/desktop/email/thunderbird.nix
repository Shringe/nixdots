{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.email.thunderbird;
in {
  options.homeManagerModules.desktop.email.thunderbird = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.email.enable;
      # default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      thunderbird
    ];

    # Declaritive config exists here
    # programs.thunderbird = {
    #   enable = true;
    # };
  };
}
