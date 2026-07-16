{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.desktop.localsend;
in
{
  options.nixosModules.desktop.localsend = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
