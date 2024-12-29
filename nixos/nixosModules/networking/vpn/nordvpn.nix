{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.nixosModules.networking.vpn.nordvpn;
in
{
  environment.systemPackages = lib.mkIf cfg.enable [
    pkgs.nur.repos.wingej0.nordvpn
  ];

  # systemd.services.nordvpnd.enable = true;
}
