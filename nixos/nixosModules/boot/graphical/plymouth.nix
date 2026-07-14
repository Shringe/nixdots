{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.boot.graphical.plymouth;
in
{
  options.nixosModules.boot.graphical.plymouth = {
    enable = mkOption {
      type = types.bool;
      # default = config.nixosModules.boot.graphical.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.plymouth.enable = false;

    boot = {
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "rd.udev.log_level=3"
        "rd.systemd.show_status=auto"
      ];

      # Enable "Silent boot"
      # consoleLogLevel = 3;
      # initrd = {
      #   verbose = false;
      #   systemd.enable = true;
      # };
      #
      # kernelParams = [
      #   "quiet"
      #   # "splash"
      #   "intremap=on"
      #   "boot.shell_on_fail"
      #   "udev.log_priority=3"
      #   "rd.systemd.show_status=auto"
      # ];

      plymouth = {
        enable = true;

        theme = "rings";
        themePackages = with pkgs; [
          # By default we would install all themes
          (adi1090x-plymouth-themes.override {
            selected_themes = [ "rings" ];
          })
        ];
      };
    };
  };
}
