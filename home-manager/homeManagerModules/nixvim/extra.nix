{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.nixvim.extra;
in {
  options.homeManagerModules.nixvim.extra = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.nixvim.enable;
      description = "Enable extra tooling for neovim workflow."; 
    };
  };

  config = mkIf cfg.enable {
    programs = {
      lazygit.enable = true;
      # neovide.enable = true;

      yazi = {
        enable = true;
        enableFishIntegration = true;

        settings = {
          opener = {
            image = [
              { run = ''feh "$@"''; orphan = true; }
            ];
          };

          open = {
            rules = [
              { mime = "image/*"; use = "image"; }
            ];
          };
        };
      };
    };
  };
}
