{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.hardware.battery;
in
{
  options.nixosModules.hardware.battery = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };

    services = {
      thermald.enable = true; # Prevents overheating on Intel
      auto-cpufreq.enable = true;
    };

    environment.systemPackages = with pkgs; [
      acpi # battery cli
    ];
  };
}
