{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.battery;
in
{
  powerManagement.enable = cfg.powerManagement.enable; # base nixos power management
  services = lib.mkIf cfg.powerManagement.enable {
    thermald.enable = true; # Prevents overheating on Intel

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

    logind = {
      lidSwitch = "suspend-then-hibernate";
      # extraConfig = ''
      #   HandlePowerKey=ignore
      # '';
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
    lib.mkIf cfg.tooling.enable [
      powertop # power usage cli
      acpi # battery cli
    ];
}
