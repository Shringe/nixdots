{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.filebrowser;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      filebrowser
    ];

    networking.firewall = {
      allowedTCPPorts = [ 8080 ];
      allowedUDPPorts = [ 8080 ];
    };
  };
}
