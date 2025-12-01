{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.matrix;
in
{
  options.homeManagerModules.desktop.matrix = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.enable;
      description = "Enables preffered matrix client";
    };

    enableExtra = mkOption {
      type = types.bool;
      default = false;
      description = "Extra matrix clients";
    };

    enableService = mkOption {
      type = types.bool;
      default = true;
      description = "Enable user service for starting prefferd client in background";
    };
  };

  config = mkIf cfg.enable {
    programs = mkMerge [
      {
        nheko.enable = true;
      }
      (mkIf cfg.enableExtra {
        element-desktop.enable = true;
      })
    ];

    systemd.user.services.nheko = mkIf cfg.enableService {
      Unit = {
        Description = "Runs nheko in the background";
        PartOf = [ config.wayland.systemd.target ];
        After = [ config.wayland.systemd.target ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${pkgs.nheko}/bin/nheko";
        Restart = "on-failure";
      };

      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
