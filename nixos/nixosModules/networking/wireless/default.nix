{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.networking.wireless;
in
{
  imports = [
    ./wpa.nix
    ./iwd.nix
  ];

  options.nixosModules.networking.wireless = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    unblockWlan = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };

  config.systemd.services.rfkillUnblockWlan = mkIf cfg.unblockWlan {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock wlan";
      RemainAfterExit = true;
    };

    wantedBy = [ "multi-user.target" ];
  };
}
