{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.email.neomutt;
in {
  options.homeManagerModules.desktop.email.neomutt = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.email.enable;
    };

    theme = mkOption {
      type = types.str;
      default = "catppuccin";
    };
  };

  config = mkIf cfg.enable {
    accounts.email.accounts = {
      "dashingkoso@deamicis.top".neomutt.enable = true;
      "dashingkoso@gmail.com".neomutt.enable = true;
      "ldeamicis12@gmail.com".neomutt.enable = true;
    };

    programs.neomutt = {
      enable = true;
      vimKeys = true;
      checkStatsInterval = 60;
      sidebar = {
        enable = true;
        width = 30;
      };

      extraConfig = builtins.readFile ./themes/${cfg.theme};
    };
  };
}
