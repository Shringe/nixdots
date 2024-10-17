{ lib, config, ... }:
{
  options = {
    shells.bash = {
    enable = lib.mkEnableOption "Enables bash shell configuration";
    atuin = lib.mkEnableOption;
    };
  };
  config.programs = {
    atuin = lib.mkIf config.shells.bash.atuin { 
      enableBashIntegration = true;
    };
    bash = lib.mkIf config.shells.bash.enable {
      enable = true;
    };
  };
}
