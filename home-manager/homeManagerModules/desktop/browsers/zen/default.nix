{
  config,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.browsers.zen;
  ff = config.homeManagerModules.desktop.browsers.firefox;
in
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  options.homeManagerModules.desktop.browsers.zen = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.browsers.enable;
    };

    useCustomCatppuccin = mkOption {
      type = types.bool;
      default = true;
      description = "Overrides stylix theme with a manual catppuccin theme.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      stylix.targets.zen-browser.profileNames = [ "default" ];

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
    }

    # https://github.com/catppuccin/zen-browser
    (mkIf cfg.useCustomCatppuccin {
      home.file =
        let
          mkLnk = file: {
            ".zen/default/chrome/${file}" = {
              source = ./${file};
              # force = true;
            };
          };
        in
        mkMerge [
          (mkLnk "zen-logo-mocha.svg")
          (mkLnk "userChrome.css")
          (mkLnk "userContent.css")
        ];
    })
  ]);
}
