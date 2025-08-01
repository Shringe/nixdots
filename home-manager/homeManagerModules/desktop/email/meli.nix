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
      "new".meli.enable = true;
      "old".meli.enable = true;
      "school".meli.enable = true;
    };

    programs.meli = {
      enable = true;
    };
  };
}
