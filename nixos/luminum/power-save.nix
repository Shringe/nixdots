{ pkgs, ... }:
{
  powerManagement.enable = true; # base nixos power management
  services = {
    thermald.enable = true; # Prevents overheating on Intel
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    logind = {
      lidSwitch = "ignore";
      extraConfig = ''
        HandlePowerKey=ignore
      '';
    };
    acpid = {
      enable = true;
      powerEventCommands = ''
        systemctl suspend
      '';
    };     
  };

  environment.systemPackages = with pkgs; [
    powertop # power usage cli
    acpi # battery cli
  ];


}
