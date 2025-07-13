{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.openrgb;

  no-rgb = pkgs.writeScriptBin "no-rgb" ''
    #!/bin/sh
    NUM_DEVICES=$(${pkgs.openrgb}/bin/openrgb --noautoconnect --list-devices | grep -E '^[0-9]+: ' | wc -l)

    for i in $(seq 0 $(($NUM_DEVICES - 1))); do
      ${pkgs.openrgb}/bin/openrgb --noautoconnect --device $i --mode static --color 000000
    done
  '';
in
{
  services = lib.mkIf cfg.enable {
    hardware.openrgb = {
      enable = false;
    };

    udev.packages = [ pkgs.openrgb ];
  };

  systemd.services.no-rgb = lib.mkIf cfg.enable {
    description = "no-rgb";
    serviceConfig = {
      ExecStart = "${no-rgb}/bin/no-rgb";
      Type = "oneshot";
    };

    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
  };

  environment.systemPackages = lib.mkIf cfg.enable [ pkgs.openrgb-with-all-plugins ];

  hardware.i2c.enable = lib.mkIf cfg.enable true;
  boot.kernelModules = lib.mkIf cfg.enable [ "i2c-dev" ];
}
