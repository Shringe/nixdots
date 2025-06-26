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
  };

  config = mkIf cfg.enable {
    accounts.email.accounts."dashingkoso@deamicis.top".neomutt.enable = true;

    programs.neomutt = {
      enable = true;
      vimKeys = true;
    };
  };
}
