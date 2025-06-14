{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.social.jitsi;
in {
  options.nixosModules.social.jitsi = {
    enable = mkEnableOption "Jitsi hosting";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = [
      "jitsi-meet-1.0.8043"
    ];

    services = {
      jitsi-meet = {
        enable = true;
        hostName = "jitsi.deamicis.top";
        nginx.enable = true;
        # caddy.enable = true;
        excalidraw.enable = true;
        secureDomain.enable = false;
      };
    };
  };
}
