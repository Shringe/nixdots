{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.browsers.chromium;
in {
  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      # package = pkgs.cromite;

      commandLineArgs = [
        "--enable-blink-features=MiddleClickAutoscroll"
      ];
    };
  };
}
