{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.gammastep;
in
{
  options.homeManagerModules.desktop.windowManagers.utils.gammastep = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.windowManagers.enable;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."gammastep" = { };

    systemd.user.services.gammastep = {
      Unit = {
        PartOf = [ config.wayland.systemd.target ];
        After = [ config.wayland.systemd.target ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${pkgs.gammastep}/bin/gammastep -c ${config.sops.secrets."gammastep".path}";
        Restart = "on-failure";
      };

      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
