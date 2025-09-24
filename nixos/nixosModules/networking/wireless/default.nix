{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.networking.wireless;
  fixWlan = pkgs.writeShellApplication {
    name = "fixWlan";

    runtimeInputs = with pkgs; [
      iproute2
      util-linux
      coreutils
    ];

    text = ''
      sleep 5
      rfkill unblock wlan
      ip link set wlan0 down
      ip link set wlan0 up
    '';
  };
in
{
  imports = [
    ./wpa.nix
    ./iwd.nix
    ./networkmanager.nix
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
      RemainAfterExit = true;
      ExecStart = "${fixWlan}/bin/fixWlan";
    };

    wantedBy = [ "multi-user.target" ];
    requisite = [ "iwd.service" ];
    after = [ "iwd.service" ];
  };
}
