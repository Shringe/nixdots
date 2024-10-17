{ lib, config, ... }:
{
  options.shells.atuin.enable = lib.mkEnableOption "Enables and configures Atuin";
  config.programs.atuin = lib.mkIf config.shells.atuin.enable {
    enable = true;
  };
}
