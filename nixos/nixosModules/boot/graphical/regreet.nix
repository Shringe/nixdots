{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.boot.graphical.regreet;

  niri-config = pkgs.writeText "niri-config" ''
    hotkey-overlay {
      skip-at-startup
    }

    environment {
      GTK_USE_PORTAL "0"
      GDK_DEBUG "no-portals"
    }

    // other settings

    spawn-at-startup "${pkgs.bash}/bin/bash" "-c" "${pkgs.greetd.regreet}/bin/regreet; ${pkgs.niri}/bin/niri msg action quit --skip-confirmation"
  '';
in
{
  options.nixosModules.boot.graphical.regreet = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.boot.graphical.enable;
      # default = false;
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.regreet.useWallpaper = false;
    programs.regreet.settings.background.path = config.nixosModules.theming.wallpapers.secondary;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.niri}/bin/niri -c ${niri-config}";
          user = "greeter";
        };
      };
    };

    programs.regreet.enable = true;
  };
}
