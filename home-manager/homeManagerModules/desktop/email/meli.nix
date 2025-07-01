{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.email.meli;
in {
  options.homeManagerModules.desktop.email.meli = {
    enable = mkOption {
      type = types.bool;
      # default = config.homeManagerModules.desktop.email.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    accounts.email.accounts = {
      "dashingkoso@deamicis.top".meli.enable = true;
      "dashingkoso@gmail.com".meli.enable = true;
      "ldeamicis12@gmail.com".meli.enable = true;
    };

    programs.meli = {
      enable = true;
    };
  };
}
