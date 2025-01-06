{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.homeManagerModules.theming.stylix;
in
{
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = lib.mkIf cfg.enable {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.homeManagerModules.theming.stylix.colorScheme}.yaml";
    image = ./wallpapers/${config.homeManagerModules.theming.wallpaper};

    targets = {
      nixvim.enable = false;
    };

    fonts = {
      serif = {
        package = pkgs.raleway;
        name = "Raleway";
      };

      sansSerif = {
        package = pkgs.raleway;
        name = "Raleway";
      };

      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };

      sizes = {
        terminal = 16;
      };
    };

    opacity = {
      terminal = 0.88;
    };
  };
}
