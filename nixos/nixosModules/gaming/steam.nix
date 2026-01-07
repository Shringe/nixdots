{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.gaming.steam;
in
{
  config = mkIf cfg.enable {
    programs = {
      gamescope = {
        enable = true;

        # Asks for setuid right now?
        # capSysNice = true;

        # Doesn't seem to work either?
        # args = [
        #   "-W 3440"
        #   "-H 1440"
        #   "-r 175"
        #   "-f"
        #   "--adaptive-sync"
        #   "--mangoapp"
        # ];
      };

      steam = {
        enable = true;
        protontricks.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };

    hardware = {
      xone.enable = true;
      graphics.enable32Bit = true;
    };
  };
}
