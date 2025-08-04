{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.shells.nushell;
in {
  options.homeManagerModules.shells.nushell = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.shells.enable;
    };
  };

  config = mkIf cfg.enable {
    programs = {
      nushell = {
        enable = true;
        shellAliases = mkForce {};
      };

      zoxide.enableNushellIntegration = true;
      yazi.enableNushellIntegration = true;
      eza.enableNushellIntegration = true;
    };
  };
}
