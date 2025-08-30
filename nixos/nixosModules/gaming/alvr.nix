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

    wivrn = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services = mkIf cfg.wivrn {
      monado.enable = true;
      wivrn = {
        enable = true;
        openFirewall = true;
        defaultRuntime = true;
      };
    };

    environment.systemPackages =
      with pkgs;
      mkIf cfg.wivrn [
        wlx-overlay-s
      ];

    programs.alvr = mkIf (!cfg.wivrn) {
      enable = true;
      openFirewall = true;
    };
  };
}
