{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.email.aerc;
in {
  options.homeManagerModules.desktop.email.aerc = {
    enable = mkOption {
      type = types.bool;
      # default = config.homeManagerModules.desktop.email.enable;
      default = false;
    };

    theme = mkOption {
      type = types.str;
      default = "catppuccin";
    };
  };

  config = mkIf cfg.enable {
    accounts.email.accounts = {
      "dashingkoso@deamicis.top".aerc.enable = true;
      "dashingkoso@gmail.com".aerc.enable = true;
      "ldeamicis12@gmail.com".aerc.enable = true;
    };

    programs.aerc = {
      enable = true;

      extraConfig = {
        general.unsafe-accounts-conf = true;
      };
    };
  };
}
