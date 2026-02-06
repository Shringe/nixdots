{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.boot.optimizations.nix;
in
{
  options.nixosModules.boot.optimizations.nix = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.boot.enable;
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.systemd.network.wait-online.timeout = 0;
    systemd.network.wait-online.timeout = 0;
    systemd.services = {

    };

    # Intended to be started AFTER multi-user.target has completed, and getty/login is starting
    systemd.targets.post-interactive = {
      after = [ "multi-user.target" ];
      wants = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
    };

    systemd.settings.Manager = {
      DefaultTimeoutStopSec = "30s";
      DefaultTimeoutStartSec = "30s";
    };
  };
}
