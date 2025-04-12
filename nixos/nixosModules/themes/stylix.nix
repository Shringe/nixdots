{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.nixosModules.theming.stylix;
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.nixosModules.theming.stylix.colorScheme}.yaml";
      image = ./../../../assets/wallpapers/${config.nixosModules.theming.wallpaper};

      # Skews auto-generated themes
      polarity = "dark";

      targets = {
        grub.enable = true;
        grub.useWallpaper = true;
        # nixvim.enable = false;
        # mangohud.enable = false;
        # firefox.profileNames = [ "default" ];
        # kde.enable = true;
        # qt.enable = true;
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
  };
}
