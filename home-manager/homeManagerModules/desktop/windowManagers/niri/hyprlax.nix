{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.niri.hyprlax;
  targets = [ "niri.service" ];

  # https://github.com/sandwichfarm/hyprlax/blob/master/docs/configuration/examples/basic.toml
  hyprlaxConfig_hdmi-a-1 = pkgs.writeText "hyprlax.toml" ''
    # Basic hyprlax configuration
    # Simple two-layer parallax wallpaper

    [global]
    fps = 175                # Lower FPS for battery saving
    debug = false
    # duration = 1.0          # 1 second workspace animation
    # shift_percent = 1.5     # 1.5% of screen width per workspace (works on any screen size)
    # vsync = true
    # easing = "expo"

    # Single background image example
    # Uncomment to use just one image:
    [[global.layers]]
    # path = "~/Pictures/wallpaper.jpg"
    path = "/nixdots/assets/wallpapers/grassmastersword_3440x1440.png"
    # shift_multiplier = 1.0
    # opacity = 1.0
  '';
in
{
  options.homeManagerModules.desktop.windowManagers.niri.hyprlax = {
    enable = mkOption {
      type = types.bool;
      # default = config.homeManagerModules.desktop.windowManagers.niri.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.hyprlax-hdmi-a-1 = {
      Install.WantedBy = targets;
      Unit = {
        After = targets;
        PartOf = targets;
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${pkgs.hyprlax}/bin/hyprlax --config ${hyprlaxConfig_hdmi-a-1}";
        Restart = "on-failure";
      };
    };
  };
}
