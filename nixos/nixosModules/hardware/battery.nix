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
    powerManagement.enable = cfg.powerManagement.enable; # base nixos power management
    services = mkIf cfg.powerManagement.enable {
      thermald.enable = true; # Prevents overheating on Intel
      auto-cpufreq.enable = true;
      logind.lidSwitch = "suspend-then-hibernate";

      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          START_CHARGE_THRESH_BAT0 = 40;
          STOP_CHARGE_THRESH_BAT0 = 90;
        };
      };

      acpid = {
        enable = true;
        powerEventCommands = ''
          systemctl suspend
        '';
      };
    };

    environment.systemPackages =
      with pkgs;
      mkIf cfg.tooling.enable [
        powertop # power usage cli
        acpi # battery cli
      ];
  };
}
