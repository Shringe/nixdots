{ config, lib, inputs, ... }:
with lib;
let 
  cfg = config.homeManagerModules.desktop.browsers.zen;
  ff = config.homeManagerModules.desktop.browsers.firefox;
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
    programs.zen-browser = {
      enable = true;

      policies = {
        DisableAppUpdate = true;
        DontCheckDefaultBrowser = true;
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
      };

      languagePacks = [ "en-US" ];
      profiles = ff.profiles;
    };
  };
}

