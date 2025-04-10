{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.sway.swaylogout;
in {
  options.homeManagerModules.desktop.windowManagers.sway.swaylogout = {
    enable = mkEnableOption "Configure swaylogout shell script";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # waylogout

      (writeShellApplication {
        name = "swaylogout";
        runtimeInputs = [
          waylogout
        ];

        text = ''
          #!/usr/bin/env sh
          waylogout \
            # --hide-cancel \
            --screenshots \
            --font="Raleway" \
            --effect-blur=7x5 \
            --indicator-thickness=20 \
            --ring-color=888888aa \
            --inside-color=88888866 \
            --text-color=eaeaeaaa \
            --line-color=00000000 \
            --ring-selection-color=33cc33aa \
            --inside-selection-color=33cc3366 \
            --text-selection-color=eaeaeaaa \
            --line-selection-color=00000000 \
            --lock-command="echo 'Demo mode, lock command not configured. See man page.'" \
            --logout-command="echo 'Demo mode, logout command not configured. See man page.'" \
            --suspend-command="echo 'Demo mode, suspend command not configured. See man page.'" \
            --hibernate-command="echo 'Demo mode, hibernate command not configured. See man page.'" \
            --poweroff-command="echo 'Demo mode, poweroff command not configured. See man page.'" \
            --reboot-command="echo 'Demo mode, reboot command not configured. See man page.'" \
            --switch-user-command="echo 'Demo mode, switch-user command not configured. See man page.'" \
            --selection-label
        '';
      })
    ];
  };
}
