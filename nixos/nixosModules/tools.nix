{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.tools;
in
{
  options.nixosModules.tools = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Recommended set of general cli tools that I like to have installed";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      stressapptest
      cargo
      usbutils
      libnotify
      cmatrix
      scc
    ];
  };
}
