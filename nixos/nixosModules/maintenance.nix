{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.maintenance;
in
{
  options.nixosModules.maintenance = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Automatic maintenance of the Nix store";
    };
  };

  config = mkIf cfg.enable {
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      optimise = {
        automatic = true;
      };
    };
  };
}
