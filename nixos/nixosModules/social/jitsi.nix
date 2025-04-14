{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.social.jitsi;
in {
  options.nixosModules.social.jitsi = {
    enable = mkEnableOption "Jitsi hosting";
    
  };

  config = mkIf cfg.enable {
    services.jitsi-meet = {
      enable = true;
      hostName = "jitsi.deamicis.top";
      nginx.enable = false;
      caddy.enable = true;
      excalidraw.enable = true;
      secureDomain.enable = true;
    };
  };
}
