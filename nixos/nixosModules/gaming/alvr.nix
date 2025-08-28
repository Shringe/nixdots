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
    services.monado.enable = true;
    services.wivrn = {
      enable = true;
      openFirewall = true;
      defaultRuntime = true;
    };

    environment.systemPackages = with pkgs; [
      wlx-overlay-s
    ];
    #
    # programs.alvr = {
    #   enable = true;
    #   openFirewall = true;
    # };
  };
}
