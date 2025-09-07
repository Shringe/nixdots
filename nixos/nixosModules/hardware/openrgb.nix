{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.hardware.openrgb;

  no-rgb = pkgs.writeScriptBin "no-rgb" ''
    #!/bin/sh
    NUM_DEVICES=$(${cfg.package}/bin/openrgb --noautoconnect --list-devices | grep -E '^[0-9]+: ' | wc -l)

    for i in $(seq 0 $(($NUM_DEVICES - 1))); do
      ${cfg.package}/bin/openrgb --noautoconnect --device $i --mode static --color 000000
    done
  '';
in
{
  options.nixosModules.hardware.openrgb = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    disableRgb = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to disable all RGB.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.openrgb-with-all-plugins;
    };
  };

  config = mkIf cfg.enable {
    services = {
      hardware.openrgb = {
        enable = false;
        package = cfg.package;
      };

      udev.packages = [
        cfg.package
      ];
    };

    environment.systemPackages = [
      cfg.package
    ];

    hardware.i2c.enable = true;
    boot.kernelModules = [ "i2c-dev" ];

    systemd.services.no-rgb = mkIf cfg.disableRgb {
      description = "no-rgb";
      serviceConfig = {
        ExecStart = "${no-rgb}/bin/no-rgb";
        Type = "oneshot";
      };

      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
    };
  };
}
