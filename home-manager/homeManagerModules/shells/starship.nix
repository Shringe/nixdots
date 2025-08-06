{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.shells.starship;
in {
  options.homeManagerModules.shells.starship = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.shells.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableTransience = true;
      enableFishIntegration = false;

      settings = {
        add_newline = false;

        character = {
          format = "\n";
        };
      };
    };
  };
}
