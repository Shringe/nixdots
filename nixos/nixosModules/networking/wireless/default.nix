{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.networking.wireless;
  fixWlanHook = pkgs.writeShellApplication {
    name = "fixWlanHook";

    runtimeInputs = with pkgs; [
      systemd
    ];

    text = ''
      case $1 in
        post) systemctl restart fixWlan
      esac
    '';
  };

  fixWlan = pkgs.writeShellApplication {
    name = "fixWlan";

    runtimeInputs = with pkgs; [
      iproute2
      util-linux
      coreutils
    ];

    text = ''
      rfkill unblock wlan
      ip link set wlan0 down
      ip link set wlan0 up
      systemctl stop wg-quick-wg0
      sleep 15
      systemctl start wg-quick-wg0
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

  config = mkIf cfg.unblockWlan {
    systemd.services.fixWlan = mkIf cfg.unblockWlan {
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${fixWlan}/bin/fixWlan";
      };

      wantedBy = [ "multi-user.target" ];
      requisite = [ "iwd.service" ];
      after = [ "iwd.service" ];
    };

    environment.etc."systemd/system-sleep/fixWlan" = {
      source = "${fixWlanHook}/bin/fixWlanHook";
      # mode = "0755";
    };
  };
}
