{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.theming;
in
{
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  options.homeManagerModules.theming = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };

    colorScheme = mkOption {
      type = types.str;
      default = "catppuccin-mocha";
      description = "What .yaml theme to use.";
    };

    wallpapers = {
      primary = mkOption {
        type = types.path;
        default = ./../../../assets/wallpapers/PurpleFluid_1920x1080.png;
        description = "Used for most things.";
      };

      secondary = mkOption {
        type = types.path;
        default = ./../../../assets/wallpapers/BlossomsCatppuccin_1920x1080.png;
        description = "Used for things like the display manager.";
      };
    };
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.colorScheme}.yaml";
      image = cfg.wallpapers.primary;

      # Skews auto-generated themes
      polarity = "dark";

      targets = {
        nixos-icons.enable = true;
        qt.enable = true;
        kde.enable = true;
      };

      cursor = {
        package = pkgs.graphite-cursors;
        name = "graphite-dark-nord";
        size = 24;
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
          terminal = 13;
        };
      };

      opacity = {
        terminal = 0.88;
        desktop = 0.88;
      };
    };
  };
}
