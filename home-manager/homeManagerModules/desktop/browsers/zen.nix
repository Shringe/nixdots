{ config, lib, inputs, ... }:
with lib;
let 
  cfg = config.homeManagerModules.desktop.browsers.zen;
in {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  options.homeManagerModules.desktop.browsers.zen = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.browsers.enable;
    };
  };

  config = mkIf cfg.enable {
    # home.packages = with pkgs; [
    #   zen
    # ];

    programs.zen-browser = {
      enable = true;

      policies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
        # find more options here: https://mozilla.github.io/policy-templates/
      };
    };
  };
}

