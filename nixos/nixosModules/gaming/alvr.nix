{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.gaming.alvr;
in
{
  options.nixosModules.gaming.alvr = {
    enable = mkOption {
      type = types.bool;
      # default = config.nixosModules.gaming.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.alvr = {
      enable = true;
      openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      sidequest
    ];
  };
}
