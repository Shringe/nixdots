{
  config,
  lib,
  pkgs,
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
    # pkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
      # ripcord
      # discord
      # vencord
    ];

    programs.nixcord = {
      enable = true;

      discord = {
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
