{
  config,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.discord;
in
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  config = mkIf cfg.enable {
    programs.nixcord = {
      enable = true;

      discord = {
        enable = false;
      };

      vesktop = {
        enable = true;
        autoscroll.enable = true;
      };

      config = {
        frameless = true;
        transparent = false;

        plugins = {
          # betterFolders.enable = true;
          betterSettings.enable = true;
          # alwaysAnimate.enable = true;
          ClearURLs.enable = true;
          callTimer.enable = true;
          # CustomRPC.enable = true;
          fakeNitro.enable = true;
        };
      };
    };
  };
}
