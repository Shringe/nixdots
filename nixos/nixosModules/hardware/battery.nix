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

    auto-cpufreq = mkOption {
      type = types.bool;
      default = cfg.enable;
    };

    tlp = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };

    systemd.sleep.extraConfig = "HibernateDelaySec=15min";

    services = {
      thermald.enable = true; # Prevents overheating on Intel

      tlp = mkIf cfg.tlp {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "powersave";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "power";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 20;

          # Optional helps save long term battery health
          START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
          STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        };
      };

      auto-cpufreq = mkIf cfg.auto-cpufreq {
        enable = true;
        settings = {
          charger = {
            governor = "performance";
            turbo = "auto";
          };

          battery = {
            governor = "powersave";
            turbo = "auto";
            enable_thresholds = true;
            start_threshold = 20;
            stop_threshold = 80;
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      acpi # battery cli
    ];
  };
}
