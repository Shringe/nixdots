{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.locale;
in
{
  options.nixosModules.locale = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to set default localization properties.";
    };
  };

  config = mkIf cfg.enable {
    time.timeZone = "US/Central";
    i18n.defaultLocale = "en_US.UTF-8";
  };
}
