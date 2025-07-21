{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.email.aerc;
in {
  options.homeManagerModules.desktop.email.aerc = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.email.enable;
      # default = false;
    };

    theme = mkOption {
      type = types.str;
      default = "catppuccin";
    };
  };

  config = mkIf cfg.enable {
    accounts.email.accounts = {
      "new".aerc.enable = true;
      "old".aerc.enable = true;
      "school".aerc.enable = true;
    };

    programs.aerc = {
      enable = true;

      stylesets = {
        catppuccin-mocha = builtins.readFile ./themes/catppuccin-mocha;
      };

      extraConfig = {
        general = {
          unsafe-accounts-conf = true;
        };

        ui = {
          border-char-vertical = "│";
          border-char-horizontal = "─";
          styleset-name = "catppuccin-mocha";
        };
      };
    };
  };
}
